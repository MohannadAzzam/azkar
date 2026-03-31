import 'package:adhan/adhan.dart';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  PrayerTimeCubit() : super(PrayerTimeInitial());

  Future<void> fetchPrayerTimes() async {
    emit(PrayerTimeLoading());
    try {
      LocationPermission locationPermission =
          await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.denied) {
          emit(
            PrayerTimeError(
              'تم رفض الوصول للموقع الجغرافي. يرجى السماح بالوصول للموقع للحصول على أوقات الصلاة.',
            ),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      final coordinates = Coordinates(31.5, 34.4);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi; // يمكنك اختيار المذهب حسب الحاجة

      final prayerTimes = PrayerTimes.today(coordinates, params);
      // يمكنك تعديل اسم المدينة حسب الحاجة
      emit(
        PrayerTimeLoaded(prayerTimes: prayerTimes, locationName: "موقعك الحالي"),
      );
    } catch (e) {
      emit(PrayerTimeError("فشل في تحديد المواقيت: ${e.toString()}"));
    }
  }
}
