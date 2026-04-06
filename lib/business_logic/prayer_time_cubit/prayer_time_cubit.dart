import 'package:adhan/adhan.dart';
import '../../data/repo/prayer_repository.dart';
import '../../services/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  final PrayerRepository _prayerRepository;
  final NotificationService _notificationService = NotificationService();

  PrayerTimeCubit(this._prayerRepository) : super(PrayerTimeInitial());

  Future<void> fetchPrayerTimes() async {
    emit(PrayerTimeLoading());

    try {
      final (times, locationName) = await _prayerRepository.getTodayPrayerTimes();

      // جدولة الإشعارات تلقائياً فور نجاح الجلب
      await scheduleAllPrayers(times);

      emit(PrayerTimeLoaded(prayerTimes: times, locationName: locationName));
    } catch (e) {
      emit(PrayerTimeError("خطأ في البيانات: ${e.toString()}"));
    }
  }

  Future<void> scheduleAllPrayers(PrayerTimes prayerTimes) async {
    
    // تحويل كافة المواعيد للتوقيت المحلي (Local) قبل الجدولة
    final Map<int, Map<String, dynamic>> prayers = {
      0: {"name": "الفجر", "time": prayerTimes.fajr.toLocal()},
      1: {"name": "الظهر", "time": prayerTimes.dhuhr.toLocal()},
      2: {"name": "العصر", "time": prayerTimes.asr.toLocal()},
      3: {"name": "المغرب", "time": prayerTimes.maghrib.toLocal()},
      4: {"name": "العشاء", "time": prayerTimes.isha.toLocal()},
    };

    prayers.forEach((id, data) async {
      DateTime prayerTime = data['time'];
      
      // نجدول فقط إذا كان الوقت لم يمر بعد
      if (prayerTime.isAfter(DateTime.now())) {
        await _notificationService.scheduleNotification(
          id,
          "حان وقت صلاة ${data['name']}",
          "حي على الصلاة.. اذكر الله يذكرك",
          prayerTime, 
        );
      }
    });

    // print("تمت جدولة الصلوات بنجاح بالتوقيت المحلي.");
  }
}