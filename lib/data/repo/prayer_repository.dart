import 'package:adhan/adhan.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// تأكد من استيراد ملف الخدمة الخاص بك، المسار قد يختلف حسب مجلداتك
import '../../services/notification_service.dart'; 

class PrayerRepository {
  // 1. يجب تعريف المتغير هنا ليكون متاحاً لكل الدوالي داخل الكلاس
  final NotificationService _notificationService = NotificationService();

  Future<(PrayerTimes, String)> getTodayPrayerTimes() async {
    Position position;
    String cityName = "فشل تحديد الموقع";

    try {
      LocationPermission locationPermission = await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
      }
      
      if (locationPermission == LocationPermission.deniedForever) {
        throw Exception("تم رفض صلاحية الموقع بشكل دائم");
      }

      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        position = lastKnown;
      } else {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
        ).timeout(const Duration(seconds: 20));
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 20));

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        List<String> parts = [];
        String? city = p.locality ?? p.subLocality ?? p.administrativeArea;
        String? country = p.country;

        if (city != null && city.isNotEmpty) parts.add(city);
        if (country != null && country.isNotEmpty) parts.add(country);
        cityName = parts.isNotEmpty ? parts.join(", ") : "موقع غير معروف";
      }
    } catch (e) {
      // إحداثيات افتراضية في حال الخطأ
      position = Position(
        latitude: 31.5, longitude: 34.4, timestamp: DateTime.now(),
        accuracy: 0, altitude: 0, heading: 0, speed: 0,
        speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0,
      );
    }

    final coordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);

    // 2. استدعاء دالة الجدولة (تأكد من كتابة الاسم صحيحاً)
    await _scheduleAllPrayers(prayerTimes);

    return (prayerTimes, cityName);
  }

  // 3. الدالة التي تقوم بعملية الجدولة الفعلية
  Future<void> _scheduleAllPrayers(PrayerTimes prayerTimes) async {
    final Map<String, DateTime> prayers = {
      'الفجر': prayerTimes.fajr,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    int id = 0;
    for (var entry in prayers.entries) {
      // هنا لن يظهر خطأ Undefined لأن _notificationService معرف فوق
      await _notificationService.scheduleNotification(
        id++,
        'موعد صلاة ${entry.key}',
        'حان الآن وقت الأذان حسب توقيت مدينتك',
        entry.value,
      );
    }
  }
} 
//import 'package:adhan/adhan.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// class PrayerRepository {
//   Future<(PrayerTimes, String)> getTodayPrayerTimes() async {
//     Position position;
//     String cityName = "فشل تحديد الموقع";

//     try {
//       LocationPermission locationPermission =
//           await Geolocator.checkPermission();

//       if (locationPermission == LocationPermission.denied) {
//         locationPermission = await Geolocator.requestPermission();
//         if (locationPermission == LocationPermission.denied) {}
//       }
//       if (locationPermission == LocationPermission.deniedForever) {
//         throw Exception("تم رفض صلاحية الموقع بشكل دائم");
//       }
//       Position? lastKnown = await Geolocator.getLastKnownPosition();
//       if(lastKnown != null) {
//         position =lastKnown;
//         print("================================= Last Known Position: ${lastKnown.latitude}, ${lastKnown.longitude}");
//       } else {
//         print("================================= No Last Known Position available.");
      
//       position =
//           // lastKnown ??
//           await Geolocator.getCurrentPosition(
//             locationSettings: LocationSettings(accuracy: LocationAccuracy.low),
//           ).timeout(Duration(seconds: 20));
//       }
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       ).timeout(Duration(seconds: 20));

//       if (placemarks.isNotEmpty) {
//        final p = placemarks.first;
  
//   // نجمع الأجزاء المتوفرة فقط ونحذف الفراغات
//   List<String> parts = [];
  
//   // جرب استخدام subLocality أو administrativeArea إذا كان locality فارغاً
//   String? city = p.locality ?? p.subLocality ?? p.administrativeArea;
//   String? country = p.country;

//   if (city != null && city.isNotEmpty) parts.add(city);
//   if (country != null && country.isNotEmpty) parts.add(country);

//   // ندمج الأجزاء بفاصلة، وإذا كانت القائمة فارغة نضع نصاً احتياطياً
//   cityName = parts.isNotEmpty ? parts.join(", ") : "موقع غير معروف";
  
//   print("----------------------------------- $cityName");
//       }
//     } catch (e) {
//       print("================================ $e");
//       // في حال الخطأ نستخدم الإحداثيات الافتراضية
//       position = Position(
//         latitude: 31.5,
//         longitude: 34.4,
//         timestamp: DateTime.now(),
//         accuracy: 0,
//         altitude: 0,
//         heading: 0,
//         speed: 0,
//         speedAccuracy: 0,
//         altitudeAccuracy: 0,
//         headingAccuracy: 0,
//       );
//     }

//     final coordinates = Coordinates(position.latitude, position.longitude);
//     final params = CalculationMethod.muslim_world_league.getParameters();
//     params.madhab = Madhab.shafi;

//     final prayerTimes = PrayerTimes.today(coordinates, params);

//     return (prayerTimes, cityName);
//   }

// }
