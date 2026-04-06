import 'dart:async';
import '../../business_logic/prayer_time_cubit/prayer_time_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  Map<String, dynamic> _getNextPrayer(dynamic times) {
    final now = DateTime.now();
    final Map<String, DateTime> localTimes = {
      "الفجر": times.fajr.toLocal(),
      "الظهر": times.dhuhr.toLocal(),
      "العصر": times.asr.toLocal(),
      "المغرب": times.maghrib.toLocal(),
      "العشاء": times.isha.toLocal(),
    };

    if (now.isBefore(localTimes["الفجر"]!))return {"name": "الفجر", "time": localTimes["الفجر"]};
    if (now.isBefore(localTimes["الظهر"]!))return {"name": "الظهر", "time": localTimes["الظهر"]};
    if (now.isBefore(localTimes["العصر"]!))return {"name": "العصر", "time": localTimes["العصر"]};
    if (now.isBefore(localTimes["المغرب"]!))return {"name": "المغرب", "time": localTimes["المغرب"]};
    if (now.isBefore(localTimes["العشاء"]!))return {"name": "العشاء", "time": localTimes["العشاء"]};

    return {
      "name": "الفجر",
      "time": localTimes["الفجر"]!.add(const Duration(days: 1)),
    };
  }

  @override
  Widget build(BuildContext context) {
    // جلب ألوان الثيم الحالي
    final theme = Theme.of(context);
    // final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      // استخدام لون الخلفية من الثيم بدلاً من اللون الثابت
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "مواقيت الصلاة",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // الألوان ستؤخذ تلقائياً من AppBarTheme في AppTheme
      ),
      body: BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
        builder: (context, state) {
          if (state is PrayerTimeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrayerTimeError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is PrayerTimeLoaded) {
            final times = state.prayerTimes;
            final nextPrayerData = _getNextPrayer(times);

            final List<Map<String, dynamic>> prayers = [
              {
                "name": "الفجر",
                "time": times.fajr.toLocal(),
                "icon": Icons.wb_twilight,
                "color": Colors.blue.shade300,
              },
              {
                "name": "الشروق",
                "time": times.sunrise.toLocal(),
                "icon": Icons.wb_sunny_outlined,
                "color": Colors.orange.shade300,
              },
              {
                "name": "الظهر",
                "time": times.dhuhr.toLocal(),
                "icon": Icons.wb_sunny,
                "color": Colors.amber.shade600,
              },
              {
                "name": "العصر",
                "time": times.asr.toLocal(),
                "icon": Icons.sunny_snowing,
                "color": Colors.deepOrange.shade400,
              },
              {
                "name": "المغرب",
                "time": times.maghrib.toLocal(),
                "icon": Icons.nights_stay,
                "color": Colors.indigo.shade400,
              },
              {
                "name": "العشاء",
                "time": times.isha.toLocal(),
                "icon": Icons.bedtime,
                "color": Colors.blueGrey.shade400,
              },
            ];

            return Column(
              children: [
                StreamBuilder<int>(
                  stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
                  builder: (context, snapshot) {
                    final now = DateTime.now();
                    final remaining = (nextPrayerData['time'] as DateTime)
                        .difference(now);

                    final hours = remaining.inHours.toString().padLeft(2, '0');
                    final minutes = (remaining.inMinutes % 60)
                        .toString()
                        .padLeft(2, '0');
                    final seconds = (remaining.inSeconds % 60)
                        .toString()
                        .padLeft(2, '0');

                    return _buildNextPrayerHeader(
                      context: context,
                      color: primaryColor,
                      nextPrayerName: nextPrayerData['name'],
                      remainingTime: "$hours:$minutes:$seconds",
                      location: state.locationName,
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: prayers.length,
                    itemBuilder: (context, index) {
                      final prayer = prayers[index];
                      final bool isNext =
                          nextPrayerData['name'] == prayer['name'];

                      return _prayerTile(
                        context,
                        prayer['name'],
                        DateFormat.jm().format(prayer['time']),
                        prayer['icon'],
                        prayer['color'],
                        isNext,
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Text(
              "يرجى تفعيل الموقع لجلب البيانات",
              style: theme.textTheme.bodyMedium,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNextPrayerHeader({
    required BuildContext context,
    required Color color,
    required String nextPrayerName,
    required String remainingTime,
    required String location,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha:0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "الصلاة القادمة: $nextPrayerName",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            remainingTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white60, size: 16),
              const SizedBox(width: 5),
              Text(location, style: const TextStyle(color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prayerTile(
    BuildContext context,
    String name,
    String time,
    IconData icon,
    Color iconColor,
    bool isCurrent,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        // استخدام لون الـ Surface من الثيم (أبيض في الفاتح، ورمادي غامق في الداكن)
        color: isCurrent
            ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: isCurrent
            ? Border.all(
                color: theme.colorScheme.primary.withValues(alpha:0.5),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withValues(alpha:0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha:0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 20),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              color: isCurrent
                  ? theme.colorScheme.primary
                  : theme
                        .textTheme
                        .bodyLarge
                        ?.color, // استخدام لون النص من الثيم
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCurrent
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyMedium?.color?.withValues(alpha:0.6),
            ),
          ),
        ],
      ),
    );
  }
}
