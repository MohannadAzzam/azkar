class ZikirCategory {
  final int id;
  final String category;
  final List<ZikirItem> content;

  ZikirCategory({
    required this.id,
    required this.category,
    required this.content,
  });

  factory ZikirCategory.fromJson(Map<String, dynamic> json) {
    return ZikirCategory(
      id: json['id'],
      category: json['category'],
      content: (json['content'] as List)
          .map((i) => ZikirItem.fromJson(i))
          .toList(),
    );
  }

}
class ZikirItem {
  final String text;
  final int count; // الهدف الثابت (مثلاً 3)
  final String description;
  int currentCounter = 0; // العداد الحالي الذي سيتغير بالضغط

  ZikirItem({
    required this.text,
    required this.count,
    required this.description,
    this.currentCounter = 0, // يبدأ من الصفر
  });

  factory ZikirItem.fromJson(Map<String, dynamic> json) {
    return ZikirItem(
      text: json['text'],
      count: json['count'],
      description: json['description'],
    );
  }
}