import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/zikir_cubit/zikir_cubit.dart';
import '../../constants/strings.dart';
import '../../data/models/zikir_category.dart';

Widget buildQuickAccess() {
  return BlocBuilder<ZikirCubit, ZikirState>(
    builder: (context, state) {
      if (state is ZikirLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is ZikirLoaded) {
        final quickAzkar = state.azkarList
            .where(
              (element) =>
                  element.category == "أذكار الصباح" ||
                  element.category == "أذكار المساء" ||
                  element.category == "أذكار النوم",
            )
            .toList();

        return SizedBox(
          height: 130,
          child: ListView.builder(
            itemCount: quickAzkar.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              final item = quickAzkar[index];

              IconData icon;
              Color color;

              if (item.category == "أذكار الصباح") {
                icon = Icons.wb_sunny_rounded;
                color = const Color(0xFFF59E0B);
              } else if (item.category == "أذكار المساء") {
                icon = Icons.dark_mode_rounded;
                color = const Color(
                  0xFF64B5F6,
                ); // تفتيح الأزرق قليلاً للوضع الداكن
              } else {
                icon = Icons.hotel_rounded;
                color = const Color(0xFF9575CD); // تفتيح البنفسجي قليلاً
              }

              return _quickCard(
                item.category,
                icon,
                color,
                context, // نمرر الـ Context لاستخدامه في جلب الثيم
                zikirCategory: item,
              );
            },
          ),
        );
      }
      return const SizedBox();
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
  // جلب بيانات الثيم الحالي
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.only(left: 12),
    child: InkWell(
      onTap: () {
        Navigator.pushNamed(context, azkarScreen, arguments: zikirCategory);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          // استخدام لون الـ Surface من الثيم (سيتحول لرمادي غامق في الداكن وتلقائياً)
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ظل أخف في الوضع الداكن
              color: isDark
                  ? Colors.black26
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          // إضافة إطار خفيف جداً في الوضع الداكن لتمييز الكروت
          border: isDark ? Border.all(color: Colors.white10, width: 1) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title.replaceAll("أذكار ", ""),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                // استخدام لون النص من الثيم ليتحول للأبيض في الداكن تلقائياً
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
