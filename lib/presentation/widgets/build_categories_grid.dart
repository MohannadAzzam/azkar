import 'package:azkar/business_logic/zikir_by_category/cubit/zikir_by_category_cubit.dart';
import 'package:azkar/constants/strings.dart';
import 'package:azkar/data/models/zikir_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryItem {
    final String title;
    final IconData icon;
    final Color color;

    CategoryItem({required this.title, required this.icon, required this.color});
  }
// 1. إنشاء كلاس بسيط لتعريف كل قسم بأيقونة ولون خاص به
Widget buildCategoriesGrid(BuildContext context) {
  // تعريف البيانات الثابتة
final List<CategoryItem> categoryUI = [
  CategoryItem(title: 'أذكار الصلاة', icon: Icons.mosque_outlined, color: const Color(0xFFF0F4F8)), // رمادي أزرق فاتح
  CategoryItem(title: 'أدعية نبوية', icon: Icons.auto_stories_outlined, color: const Color(0xFFE6FFFA)), // تيل فاتح جداً
  CategoryItem(title: 'أذكار الطعام', icon: Icons.restaurant_menu_outlined, color: const Color(0xFFFFFBEB)), // كريمي
  CategoryItem(title: 'دعاء ختم القرآن', icon: Icons.menu_book_outlined, color: const Color(0xFFFAF5FF)), // لافندر فاتح
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
            childAspectRatio: 1.1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemCount: categoryUI.length,
          itemBuilder: (context, index) {
            final uiItem = categoryUI[index];

            // البحث عن البيانات المطابقة في القائمة القادمة من Cubit
            final actualData = state.azkarList.firstWhere(
              (element) => element.category.trim() == uiItem.title.trim(),
              orElse: () => ZikirCategory(id: 0, category: uiItem.title, content: []),
            );

            return InkWell(
              onTap: () {
                if (actualData.content.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    azkarScreen,
                    arguments: actualData,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('سيتم إضافة هذا القسم قريباً إن شاء الله'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                decoration: BoxDecoration(
                  color: uiItem.color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: uiItem.color.withOpacity(0.5), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        uiItem.icon,
                        size: 36,
                        color: Colors.black87.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      uiItem.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      
      // في حالة الخطأ أو الحالة الابتدائية
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('حدث خطأ أثناء تحميل التصنيفات'),
        ),
      );
    },
  );
}