import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';

class PrayerRepository {
  Future<PrayerTimes> getTodayPrayerTimes() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'تم رفض الوصول للموقع الجغرافي';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'صلاحيات الموقع مرفوضة نهائياً، يرجى تفعيلها من الإعدادات';
    }

    
    Position position;
    try {
      // حاول جلب آخر موقع معروف (سريع جداً ولحظي)
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      
      if (lastKnown != null) {
        position = lastKnown;
      } else {
        // إذا لم يوجد، اطلب الموقع الحالي مع تحديد وقت انتظار (مثلاً 5 ثواني)
        // إذا انتهت الـ 5 ثواني ولم يستجب الـ GPS، سينتقل للـ catch
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low, // دقة منخفضة لسرعة الاستجابة
          ),
        ).timeout(const Duration(seconds: 5));
      }
    } catch (e) {
      // في حال فشل الـ GPS تماماً، نستخدم إحداثيات افتراضية (مثلاً القاهرة أو غزة) 
      // لضمان عدم تعليق الشاشة على "Loading"
      position = Position(
        latitude: 31.5, longitude: 34.4, 
        timestamp: DateTime.now(), accuracy: 0, altitude: 0, 
        heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0,
      );
    }

    
    final coordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;

    return PrayerTimes.today(coordinates, params);
  }
}