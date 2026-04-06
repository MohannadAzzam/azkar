import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationEnabled = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // تحميل الإعدادات المحفوظة (الثيم والإشعارات)
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationEnabled = prefs.getBool('notifications_enabled') ?? true;
      _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    });
  }

  // تغيير حالة الإشعارات
  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationEnabled = value;
    });
    await prefs.setBool('notifications_enabled', value);

    if (value) {
      // استدعِ دالة الجدولة الخاصة بك هنا
      // await NotificationService.scheduleAzkar();
    } else {
      // إلغاء كافة الإشعارات المجدولة فوراً من ذاكرة النظام
      await NotificationService.cancelAllNotifications();
    }
  }

  // تغيير وضع الثيم

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // كرت الوضع الداكن
          Card(
            child: ListTile(
              leading: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.teal,
              ),
              title: const Text("الوضع الداكن", style: TextStyle(fontSize: 18)),
              trailing: Switch(
                value: _isDarkMode,
                activeThumbColor: Colors.teal,
                onChanged: (value) async {
                 setState(() {
    _isDarkMode = value;
  });
  
  // 1. حفظ في الإعدادات
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('is_dark_mode', value);
  
  // 2. تحديث التطبيق بالكامل لحظياً
  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // كرت الإشعارات
          Card(
            child: ListTile(
              leading: Icon(
                _isNotificationEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: Colors.teal,
              ),
              title: const Text(
                "تفعيل الإشعارات",
                style: TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                value: _isNotificationEnabled,
                activeThumbColor: Colors.teal,
                onChanged: (value) {
                  
                  _toggleNotifications(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
