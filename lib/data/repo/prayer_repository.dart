import 'package:adhan/adhan.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PrayerRepository {
  Future<(PrayerTimes, String)> getTodayPrayerTimes() async {
    Position position;
    String cityName = "غزة، فلسطين";

    try {
      // التأكد من الصلاحيات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // محاولة جلب الموقع (مع مهلة قصيرة للمحاكي)
      position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.low,
          forceLocationManager: true,
          timeLimit: Duration(seconds: 3),
        ),
      );

      // محاولة جلب اسم المدينة من الإحداثيات
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(const Duration(seconds: 2));
        if (placemarks.isNotEmpty) {
          cityName =
              "${placemarks.first.locality ?? placemarks.first.administrativeArea}, ${placemarks.first.country}";
        }
      } catch (_) {
        cityName = "موقعك الحالي";
      }
    } catch (e) {
      // إحداثيات غزة يدوياً في حال فشل الحساسات
      position = Position(
        latitude: 31.5,
        longitude: 34.4,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }

    final coordinates = Coordinates(position.latitude, position.longitude);

    // ضبط المعايير: Egyptian هي الأنسب لفلسطين ومصر
    // Muslim World League هي الأنسب لأوروبا
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    // تمرير التاريخ الحالي (بناءً على وقت الجهاز)
    // final date = DateComponents.from(DateTime.now());
    final prayerTimes = PrayerTimes.today(coordinates, params);

    return (prayerTimes, cityName);
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
