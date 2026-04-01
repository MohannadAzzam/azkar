import 'package:adhan/adhan.dart';
import 'package:azkar/data/repo/prayer_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  final PrayerRepository _prayerRepository ;
  PrayerTimeCubit(this._prayerRepository) : super(PrayerTimeInitial());

  Future<void> fetchPrayerTimes() async {
    if (state is PrayerTimeLoaded) return;
    emit(PrayerTimeLoading());

    try {

final prayerTimes = await _prayerRepository.getTodayPrayerTimes();

emit(PrayerTimeLoaded(
          prayerTimes: prayerTimes,
          locationName: "موقعك الحالي",
        ),
      );
      emit(
        PrayerTimeLoaded(
          prayerTimes: prayerTimes,
          locationName: "موقعك الحالي",
        ),
      );
    } catch (e) {
      emit(PrayerTimeError("حدث خطأ : ${e.toString()}"));
    }
  }
}
