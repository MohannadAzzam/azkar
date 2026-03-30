import 'package:azkar/business_logic/zikir_by_category/cubit/zikir_by_category_cubit.dart';
import 'package:azkar/constants/strings.dart';
import 'package:azkar/data/models/zikir_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryItem {
  final String title;
  final IconData icon;
  final Color accentColor; // اللون الأساسي للأيقونة والخلفية الخفيفة

  CategoryItem({required this.title, required this.icon, required this.accentColor});
}

Widget buildCategoriesGrid(BuildContext context) {
  final List<CategoryItem> categoryUI = [
    CategoryItem(title: 'أذكار الصلاة', icon: Icons.mosque_outlined, accentColor: Colors.teal),
    CategoryItem(title: 'أدعية نبوية', icon: Icons.auto_stories_outlined, accentColor: Colors.blueAccent),
    CategoryItem(title: 'أذكار الطعام', icon: Icons.restaurant_menu_outlined, accentColor: Colors.orange),
    CategoryItem(title: 'دعاء ختم القرآن', icon: Icons.menu_book_outlined, accentColor: Colors.purple),
  ];

  return BlocBuilder<ZikirByCategoryCubit, ZikirByCategoryState>(
    builder: (context, state) {
      if (state is ZikirLoading) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (state is ZikirLoaded) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2, // تحسين النسبة لتكون البطاقة أكثر عرضاً
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: categoryUI.length,
          itemBuilder: (context, index) {
            final uiItem = categoryUI[index];

            final actualData = state.azkarList.firstWhere(
              (element) => element.category.trim() == uiItem.title.trim(),
              orElse: () => ZikirCategory(id: 0, category: uiItem.title, content: []),
            );

            return InkWell(
              onTap: () {
                if (actualData.content.isNotEmpty) {
                  Navigator.pushNamed(context, azkarScreen, arguments: actualData);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('سيتم إضافة هذا القسم قريباً إن شاء الله', textAlign: TextAlign.center),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(20),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // توحيد خلفية البطاقات للون الأبيض
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04), // ظل ناعم جداً متسق مع باقي التطبيق
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // أيقونة بتصميم "دائرة باستيل" مثل Quick Access
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: uiItem.accentColor.withValues(alpha:  0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        uiItem.icon,
                        size: 32,
                        color: uiItem.accentColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      uiItem.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436), // لون خط غامق هادئ
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      
      return const Center(child: Text('حدث خطأ أثناء تحميل التصنيفات'));
    },
  );
}