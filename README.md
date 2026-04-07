# Azkar App (تطبيق الأذكار) 🌙

تطبيق إسلامي متكامل تم بناؤه باستخدام **Flutter**، يهدف إلى تزويد المستخدم بالأذكار اليومية وأوقات الصلاة بدقة عالية، مع ميزات متقدمة للتنبيهات والموقع الجغرافي.

## 🌟 المميزات الرئيسية (Core Features)

* **أوقات الصلاة:** حساب دقيق لمواقيت الصلاة باستخدام حزمة `adhan`.
* **الأذكار:** عرض الأذكار مصنفة ومدعومة بملفات JSON محلية (`azkar_by_category.json`).
* **التنبيهات الذكية:** نظام إشعارات محلي باستخدام `flutter_local_notifications` لتذكير المستخدم بالأذكار في أوقاتها.
* **تحديد الموقع:** استخدام `geolocator` و `geocoding` لجلب مواقيت الصلاة بناءً على موقع المستخدم الحالي.
* **إدارة الحالة (State Management):** الاعتماد الكلي على نمط **BLoC/Cubit** لضمان فصل المنطق عن الواجهات وسلاسة الأداء.
* **التخصيص:** دعم الخطوط العربية من خلال `google_fonts` وتعدد اللغات باستخدام `flutter_localization`.

## 🛠 التقنيات والمكتبات (Tech Stack)

* **Logic:** `bloc` & `flutter_bloc`
* **Time & Location:** `adhan`, `timezone`, `geolocator`, `geocoding`
* **Storage:** `shared_preferences` (لحفظ الإعدادات وتفضيلات المستخدم)
* **UI Components:** `google_fonts`, `cupertino_icons`
* **Data Handling:** `intl` لتنسيق الوقت والتاريخ.

## 📂 هيكلية البيانات (Assets)

يعتمد التطبيق على بيانات منظمة مخزنة داخل مجلد `assets`:
* `assets/data/azkar.json`: القائمة الشاملة للأذكار.
* `assets/data/azkar_by_category.json`: الأذكار مقسمة حسب الفئات (أذكار الصباح، المساء، النوم، إلخ).
* `assets/images/logo.png`: أيقونة التطبيق الرسمية.
