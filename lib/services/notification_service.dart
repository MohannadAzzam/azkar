import '../main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();

    // جلب المنطقة الزمنية الفعلية للجهاز (خطوة حرجة جداً)
    try {
      final timezoneinfo = await FlutterTimezone.getLocalTimezone();
      final String currentTimeZone = timezoneinfo.identifier;
      print("Current time zone $currentTimeZone");
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      tz.setLocalLocation(tz.UTC); // احتياطي: UTC
      print("Error setting local timezone: $e");
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // ScaffoldMessenger.of(BuildContext).showSnackBar(snackBar)
      },
    );

    // طلب صلاحيات أندرويد 13 فما فوق
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  // أضف هذه الدالة داخل كلاس NotificationService
  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'instant_channel', // معرف القناة
          'تنبيهات فورية', // اسم القناة
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: 0, // ID فريد للإشعار الفوري
      title: title,
      body: body,
      notificationDetails: platformDetails,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print("تم حذف جميع الاشعارات");
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      // تحويل DateTime العادي إلى TZDateTime المتوافق مع المنطقة الزمنية
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_channel',
          'مواقيت الصلاة',
          channelDescription: 'تنبيهات الأذان والصلوات',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      // UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // لتكرارها يومياً
    );
  }
}