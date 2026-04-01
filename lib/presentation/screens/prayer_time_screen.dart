import 'dart:async'; 
import 'package:azkar/business_logic/prayer_time_cubit/prayer_time_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  

  Map<String, dynamic> _getNextPrayer(dynamic times) {
    final now = DateTime.now();
    if (now.isBefore(times.fajr)) return {"name": "الفجر", "time": times.fajr};
    if (now.isBefore(times.dhuhr)) return {"name": "الظهر", "time": times.dhuhr};
    if (now.isBefore(times.asr)) return {"name": "العصر", "time": times.asr};
    if (now.isBefore(times.maghrib)) return {"name": "المغرب", "time": times.maghrib};
    if (now.isBefore(times.isha)) return {"name": "العشاء", "time": times.isha};
    // إذا انتهت صلوات اليوم، الصلاة القادمة هي فجر الغد
    return {"name": "الفجر", "time": times.fajr.add(const Duration(days: 1))};
  }

  

  @override
  Widget build(BuildContext context) {



    final Color primaryColor = Colors.teal.shade700;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("مواقيت الصلاة", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
        
        builder: (context, state) {
          
          if (state is PrayerTimeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrayerTimeError) {
            return Center(child: Text(state.message, style: TextStyle(color: Colors.red.shade400)));
          } else if (state is PrayerTimeLoaded) {
            // داخل الـ BlocBuilder عند حالة PrayerTimeLoaded
final times = state.prayerTimes;
final nextPrayerData = _getNextPrayer(times);

// قائمة منسقة للبيانات لتمريرها للـ ListView.builder
final List<Map<String, dynamic>> prayers = [
  {"name": "الفجر", "time": DateFormat.jm().format(times.fajr), "icon": Icons.wb_twilight, "color": Colors.blue.shade300},
  {"name": "الشروق", "time": DateFormat.jm().format(times.sunrise), "icon": Icons.wb_sunny_outlined, "color": Colors.orange.shade300},
  {"name": "الظهر", "time": DateFormat.jm().format(times.dhuhr), "icon": Icons.wb_sunny, "color": Colors.amber.shade600},
  {"name": "العصر", "time": DateFormat.jm().format(times.asr), "icon": Icons.sunny_snowing, "color": Colors.deepOrange.shade400},
  {"name": "المغرب", "time": DateFormat.jm().format(times.maghrib), "icon": Icons.nights_stay, "color": Colors.indigo.shade400},
  {"name": "العشاء", "time": DateFormat.jm().format(times.isha), "icon": Icons.bedtime, "color": Colors.blueGrey.shade800},
];
           
return Column(
  children: [
    // الهيدر (يبقى ثابتاً في الأعلى)
    StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final remaining = (nextPrayerData['time'] as DateTime).difference(now);
        final hours = remaining.inHours.toString().padLeft(2, '0');
        final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

        return _buildNextPrayerHeader(
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
          final bool isNext = nextPrayerData['name'] == prayer['name'];

          // نستخدم TweenAnimationBuilder لكل عنصر على حدة
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            // هنا السر: كل عنصر يتأخر 100ms عن الذي قبله
            duration: Duration(milliseconds: 500 + (index * 100)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)), // انزلاق بسيط للأعلى
                  child: _prayerTile(
                    prayer['name'],
                    prayer['time'],
                    prayer['icon'],
                    prayer['color'],
                    isNext,
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  ],
);
          }
          return const Center(child: Text("Unknown state"));
        },
      ),
    );
  }

  // ميثود الهيدر (بقيت كما هي مع استقبال القيم الديناميكية)
  Widget _buildNextPrayerHeader({
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
      ),
      child: Column(
        children: [
          Text("الصلاة القادمة: $nextPrayerName", style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            remainingTime,
            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 2),
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

  // ميثود السطر (بقيت كما هي)
  Widget _prayerTile(String name, String time, IconData icon, Color iconColor, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.teal.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isCurrent ? Border.all(color: Colors.teal.shade300, width: 1.5) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 20),
          Text(name, style: TextStyle(fontSize: 18, fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500, color: isCurrent ? Colors.teal.shade900 : Colors.black87)),
          const Spacer(),
          Text(time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isCurrent ? Colors.teal : Colors.grey.shade600)),
        ],
      ),
    );
  }
}