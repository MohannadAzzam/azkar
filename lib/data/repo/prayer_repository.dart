import 'package:adhan/adhan.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PrayerRepository {
  Future<(PrayerTimes, String)> getTodayPrayerTimes() async {
    Position position;
    String cityName = "فشل تحديد الموقع";
  
    try {
      LocationPermission locationPermission =
          await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.denied) {
        }
      }
      if (locationPermission == LocationPermission.deniedForever) {
        throw Exception("تم رفض صلاحية الموقع بشكل دائم");
      }  
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      position =
          lastKnown ??
          await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.low),
          ).timeout(Duration(seconds: 5));
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(Duration(seconds: 5));

      if (placemarks.isNotEmpty) {
        cityName = "${placemarks.first.locality}, ${placemarks.first.country}";
        print("----------------------------------- ${cityName}");
      }
    } catch (e) {
      // في حال الخطأ نستخدم الإحداثيات الافتراضية
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
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);

    return (prayerTimes, cityName);
  }
}
