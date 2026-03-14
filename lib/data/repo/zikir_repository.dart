import 'dart:convert';
import 'package:azkar/data/models/zikir_category.dart';
import 'package:flutter/services.dart';

class ZikirRepository {
  
  // دالة لجلب كل الأذكار من ملف الـ JSON
  Future<List<ZikirCategory>> getAllAzkar() async {
    try {
      // 1. قراءة الملف كـ String
      final String response = await rootBundle.loadString('assets/data/azkar.json');
      
      // 2. تحويل النص إلى List أو Map (حسب شكل الـ JSON عندك)
      final List<dynamic> data = json.decode(response);
      
      // 3. تحويل كل عنصر في القائمة إلى Object باستخدام الـ factory الذي شرحناه
      return data.map((json) => ZikirCategory.fromJson(json)).toList();
    } catch (e) {
      // يمكنك هنا معالجة الأخطاء (مثل ملف مفقود أو خطأ في الصيغة)
      throw Exception("خطأ في تحميل الأذكار: $e");
    }
  }
}