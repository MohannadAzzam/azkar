import 'package:adhan/adhan.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PrayerRepository {
  // لاحظ التغيير في نوع الإرجاع ليعيد قيمتين (PrayerTimes, String)
  Future<(PrayerTimes, String)> getTodayPrayerTimes() async {
    // ... كود الصلاحيات كما هو ...

    Position position;
    String cityName = "غزة، فلسطين"; // قيمة افتراضية

    try {
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      position = lastKnown ?? await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      ).timeout(const Duration(seconds: 5));

      // جلب اسم المدينة الحقيقي
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        cityName = "${placemarks.first.locality}, ${placemarks.first.country}";
      }
    } catch (e) {
      // في حال الخطأ نستخدم الإحداثيات الافتراضية
      position = Position(
        latitude: 31.5, longitude: 34.4, 
        timestamp: DateTime.now(), accuracy: 0, altitude: 0, 
        heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0,
      );
    }

    final coordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);
    
    // إرجاع القيمتين معاً
    return (prayerTimes, cityName);
  }
}