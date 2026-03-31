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
        final quickAzkar = state.azkarList
            .where(
              (element) =>
                  element.category == "أذكار الصباح" ||
                  element.category == "أذكار المساء" ||
                  element.category == "أذكار النوم",
            )
            .toList();

        return SizedBox(
          height: 130, // طول متناسق مع حجم العناصر
          child: ListView.builder(
            itemCount: quickAzkar.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              final item = quickAzkar[index];

              IconData icon;
              Color color;
              
              // تخصيص الألوان لتكون متناسقة مع روح التطبيق
              if (item.category == "أذكار الصباح") {
                icon = Icons.wb_sunny_rounded;
                color = const Color(0xFFF59E0B); // برتقالي ذهبي
              } else if (item.category == "أذكار المساء") {
                icon = Icons.dark_mode_rounded;
                color = const Color(0xFF3F51B5); // أزرق ملكي
              } else {
                icon = Icons.hotel_rounded;
                color = const Color(0xFF673AB7); // بنفسجي هادئ
              }

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
  return Padding(
    padding: const EdgeInsets.only(left: 12), // مسافة بين الكروت
    child: InkWell(
      onTap: () {
        Navigator.pushNamed(context, azkarScreen, arguments: zikirCategory);
      },
      borderRadius: BorderRadius.circular(20), // لضمان أن تأثير الضغطة دائري
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), // ظل ناعم جداً
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // دائرة خلفية للأيقونة لتعطي مظهراً عصرياً
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title.replaceAll("أذكار ", ""), // تبسيط النص (مثلاً "الصباح" بدلاً من "أذكار الصباح")
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF424242),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}