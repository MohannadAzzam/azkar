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

  Object? operator [](String other) {}
}

class ZikirItem {
  final String text;
  final int count;
  final String description;

  ZikirItem({
    required this.text,
    required this.count,
    required this.description,
  });

  factory ZikirItem.fromJson(Map<String, dynamic> json) {
    return ZikirItem(
      text: json['text'],
      count: json['count'],
      description: json['description'],
    );
  }
}
