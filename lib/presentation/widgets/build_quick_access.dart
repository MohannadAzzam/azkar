import '../../business_logic/zikir_cubit/zikir_cubit.dart';
import '../../constants/strings.dart';
import '../../data/models/zikir_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildQuickAccess() {
  return BlocBuilder<ZikirCubit, ZikirState>(
    builder: (context, state) {
      if (state is ZikirLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is ZikirLoaded) {
        // نقوم بفلترة الأذكار الأساسية فقط لتعرض في القائمة العلوية
        final quickAzkar = state.azkarList
            .where(
              (element) =>
                  element.category == "أذكار الصباح" ||
                  element.category == "أذكار المساء" ||
                  element.category == "أذكار النوم",
            )
            .toList();

        return SizedBox(
          height: 150, // زدنا الطول قليلاً ليناسب التصميم الجديد
          child: ListView.builder(
            itemCount: quickAzkar.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final item = quickAzkar[index];

              // نحدد الأيقونة واللون بناءً على اسم القسم
              IconData icon;
              Color color;

              if (item.category == "أذكار الصباح") {
                icon = Icons.wb_sunny_rounded;
                color = const Color(0xFFFFA726); // برتقالي دافئ
              } else if (item.category == "أذكار المساء") {
                icon = Icons.nightlight_round;
                color = const Color(0xFF5C6BC0); // أزرق ليلي
              } else {
                icon = Icons.bedtime_rounded;
                color = const Color(0xFF7E57C2); // بنفسجي هادئ
              }

              // هنا نستدعي الـ Widget الجميل الذي صممناه
              return _quickCard(
                item.category,
                icon,
                color,
                context,
                zikirCategory: item,
              );
            },
          ),
        );
      }

      return const SizedBox(); // في حال فشل التحميل لا يظهر شيء مزعج
    },
  );
}

Widget _quickCard(
  String title,
  IconData icon,
  Color color,
  BuildContext context, {
  ZikirCategory? zikirCategory,
}) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, azkarScreen, arguments: zikirCategory);
    },
    child: Container(
      width: 140,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        // color: Colors.white,
        border: BoxBorder.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
