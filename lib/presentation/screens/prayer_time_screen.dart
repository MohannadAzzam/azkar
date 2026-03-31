import 'package:azkar/business_logic/prayer_time_cubit/prayer_time_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.teal.shade700;

    return BlocProvider(
      create: (context) => PrayerTimeCubit()..fetchPrayerTimes(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            "مواقيت الصلاة",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red.shade400),
                ),
              );
            } else if (state is PrayerTimeLoaded) {
                // print(DateFormat.jm().format(prayerTimes.fajr));

              final times = state.prayerTimes;
              times.nextPrayerByDateTime;
              // var = DateFormat.jm().format(times.fajr);
              // يمكنك استخدام state.prayerTimes و state.locationName لعرض البيانات الحقيقية
              return Column(
                children: [

                  // الجزء العلوي: الصلاة القادمة (Hero Section)
                  _buildNextPrayerHeader(primaryColor),
                  // _prayerTile("الفجر", times.fajr, Icons, iconColor, isCurrent)
                  const SizedBox(height: 20),

                  // قائمة الصلوات
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _prayerTile(
                          "الفجر",
                          "${times.fajr.toString().substring(11, 16)} AM",
                          Icons.wb_twilight,
                          Colors.blue.shade300,
                          false,
                        ),
                        _prayerTile(
                          "الشروق",
                          "${times.sunrise.toString().substring(11, 16)} AM",
                          Icons.wb_sunny_outlined,
                          Colors.orange.shade300,
                          false,
                        ),
                        _prayerTile(
                          "الظهر",
                          "${times.dhuhr.toString().substring(11, 16)} PM",
                          Icons.wb_sunny,
                          Colors.amber.shade600,
                          true,
                        ), // الصلاة الحالية مثلاً
                        _prayerTile(
                          "العصر",
                          "${times.asr.toString().substring(11, 16)} PM",
                          Icons.sunny_snowing,
                          Colors.deepOrange.shade400,
                          false,
                        ),
                        _prayerTile(
                          "المغرب",
                          "${times.maghrib.toString().substring(11, 16)} PM",
                          Icons.nights_stay,
                          Colors.indigo.shade400,
                          false,
                        ),
                        _prayerTile(
                          "العشاء",
                          "${times.isha.toString().substring(11, 16)} PM",
                          Icons.bedtime,
                          Colors.blueGrey.shade800,
                          false,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text("Unknown state"));
          },
        ),
      ),
    );
  }

  // بطاقة الصلاة القادمة
  Widget _buildNextPrayerHeader(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          const Text(
            "الصلاة القادمة: العصر",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            "03:22:15",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.location_on, color: Colors.white60, size: 16),
              SizedBox(width: 5),
              Text("القاهرة، مصر", style: TextStyle(color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }

  // سطر الصلاة الواحدة
  Widget _prayerTile(
    String name,
    String time,
    IconData icon,
    Color iconColor,
    bool isCurrent,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.teal.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isCurrent
            ? Border.all(color: Colors.teal.shade300, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              color: iconColor.withValues(alpha: 0.1),
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
              color: isCurrent ? Colors.teal.shade900 : Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCurrent ? Colors.teal : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
