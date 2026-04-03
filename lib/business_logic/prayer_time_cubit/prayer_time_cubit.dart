import 'package:adhan/adhan.dart';
import 'package:azkar/data/repo/prayer_repository.dart';
import 'package:azkar/services/notification_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  final PrayerRepository _prayerRepository;
  PrayerTimeCubit(this._prayerRepository) : super(PrayerTimeInitial());

  Future<void> fetchPrayerTimes() async {
    if (state is PrayerTimeLoaded) return;
    emit(PrayerTimeLoading());
    try {
      final (times, locationName) = await _prayerRepository
          .getTodayPrayerTimes();
      emit(PrayerTimeLoaded(prayerTimes: times, locationName: locationName));
    } catch (e) {
      emit(PrayerTimeError("حدث خطأ : ${e.toString()}"));
    }
  }

  void scheduleAllPrayers(PrayerTimes prayerTimes) {
    final service = NotificationService();
    service.scheduleNotification(1, "title", "body", DateTime.now().add(Duration(seconds: 10)));  
  }
}
