class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final int categoryId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'categoryId': categoryId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      categoryId: map['categoryId'],
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    int? categoryId,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
