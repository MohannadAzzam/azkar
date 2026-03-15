import 'package:azkar/constants/strings.dart';
import 'package:azkar/data/models/zikir_category.dart';
import 'package:flutter/material.dart';

class AzkarScreen extends StatelessWidget {
  final ZikirCategory zikirCategory;
  const AzkarScreen({super.key, required this.zikirCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(zikirCategory.category)),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: zikirCategory.content.length,
        itemBuilder: (context, index) {
          // final category = state.azkarList[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 12),

            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: Text(
                textAlign: TextAlign.end,
                zikirCategory.content[index].text,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                zikirCategory.content[index].description,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
