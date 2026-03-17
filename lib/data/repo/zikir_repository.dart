import 'dart:convert';
import '../models/zikir_category.dart';
import 'package:flutter/services.dart';

class ZikirRepository {
  Future<List<ZikirCategory>> getAllAzkar() async {
    try {
      //read a json file as a string
      final String response = await rootBundle.loadString(
        'assets/data/azkar.json',
      );
    
      // change the string json file to List
      final List<dynamic> data = json.decode(response);

      return data.map((json) => ZikirCategory.fromJson(json)).toList();
    } catch (e) {
      throw Exception("خطأ في تحميل الأذكار: $e");
    }
  }
}
