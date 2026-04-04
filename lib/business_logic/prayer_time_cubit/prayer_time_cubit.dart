import 'package:adhan/adhan.dart';
import 'package:azkar/data/repo/prayer_repository.dart';
import 'package:azkar/services/notification_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  final PrayerRepository _prayerRepository;
  // يفضل تعريف الـ Service هنا لعدم تكرار إنشائه
  final NotificationService _notificationService = NotificationService();

  PrayerTimeCubit(this._prayerRepository) : super(PrayerTimeInitial());

  Future<void> fetchPrayerTimes() async {
    if (state is PrayerTimeLoaded) return;
    emit(PrayerTimeLoading());

    try {
      final (times, locationName) = await _prayerRepository
          .getTodayPrayerTimes();

      // بمجرد نجاح الجلب، نقوم بجدولة الإشعارات تلقائياً
      await scheduleAllPrayers(times);

      emit(PrayerTimeLoaded(prayerTimes: times, locationName: locationName));
    } catch (e) {
      emit(PrayerTimeError("حدث خطأ : ${e.toString()}"));
    }
  }

  Future<void> scheduleAllPrayers(PrayerTimes prayerTimes) async {
    print('يجب ان يرسل اشعار خلال 10 ثواني من الان');
    await _notificationService.scheduleNotification(
      99,
      "فحص التنبيهات",
      "هذا التنبيه للاختبار فقط",
      DateTime.now().add(Duration(seconds: 10)), // بعد دقيقة واحدة
    );

    // 1. تعريف الصلوات وأوقاتها في قائمة
    final Map<int, Map<String, dynamic>> prayers = {
      0: {"name": "الفجر", "time": prayerTimes.fajr},
      1: {"name": "الظهر", "time": prayerTimes.dhuhr},
      2: {"name": "العصر", "time": prayerTimes.asr},
      3: {"name": "المغرب", "time": prayerTimes.maghrib},
      4: {"name": "العشاء", "time": prayerTimes.isha},
    };

    // 2. Loop للمرور على كل صلاة وجدولتها
    prayers.forEach((id, data)  async {
      _notificationService.scheduleNotification(
        id, // معرف فريد (0, 1, 2...)
        "حان وقت صلاة ${data['name']}",
        "حي على الصلاة.. لا تنسَ أذكار بعد الصلاة",
        data['time'], // الوقت الحقيقي من المكتبة
      );
 
    });

    print("تمت جدولة جميع الصلوات بنجاح!");
  }
}
