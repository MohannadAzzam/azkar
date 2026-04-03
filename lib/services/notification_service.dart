import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // التعديل هنا: استخدام named parameter 'onDidReceiveNotificationResponse'
    await _notificationsPlugin.initialize(
      onDidReceiveNotificationResponse: (details) {
        // ماذا يحدث عند الضغط على الإشعار
      }, settings: initializationSettings,
    );
  }

  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'prayer_channel',
      'Prayer Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    // التعديل هنا: تمرير القيم كـ Named Parameters
    await _notificationsPlugin.show(
      id: 0, // id
      title: title, // title
      body: body, // body
      payload: null,
      notificationDetails: platformDetails,
    );
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledDate) async {
    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_id',
          'Prayer Alarms',
          channelDescription: 'Notifications for prayer times',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      // التعديل هنا: أسماء الباراميترز الجديدة
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // payload: null,
        // matchDateTimeComponents: DateTimeComponents.values
    );
  }
}