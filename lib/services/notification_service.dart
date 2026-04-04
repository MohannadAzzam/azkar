import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // طلب الإذن لأجهزة أندرويد 13+
    await _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // ماذا يحدث عند الضغط على الإشعار
      },
    );
  }

  Future<void> showInstantNotification(String title, String body) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'azkar_channel',
      'Daily Azkar',
      styleInformation: BigTextStyleInformation(body),
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id :0, // id
      title : title , // title
      body: body, // body
      notificationDetails: platformDetails,
    );
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledDate) async {
    // حماية: لا نجدول وقتاً قد مضى
    if (scheduledDate.isBefore(DateTime.now())) return;

    await _notificationsPlugin.zonedSchedule(
      id: id ,
      title : title ,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_id',
          'Prayer Alarms',
          channelDescription: 'Notifications for prayer times',
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(body), // لعرض الذكر كاملاً
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      //  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, 
       matchDateTimeComponents: DateTimeComponents.dateAndTime  
      // هذا السطر إجباري لكي تعمل الجدولة
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}