import 'package:flutter/material.dart';

Widget buildCategoriesGrid() {
  final categories = [
    'أدعية نبوية',
    'أذكار الصلاة',
    'أذكار السفر',
    'أذكار الطعام',
  ];
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    ),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(categories[index], style: const TextStyle(fontSize: 16)),
        ),
      );
    },
  );
}
