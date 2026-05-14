class ChatSummary {
  const ChatSummary({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.title,
  });

  factory ChatSummary.fromJson(Map<String, Object?> json) {
    return ChatSummary(
      id: json['id'] as String? ?? '',
      title: json['title'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  final String id;
  final String? title;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get displayTitle {
    final value = title?.trim();
    if (value != null && value.isNotEmpty) return value;
    return 'Chat ${id.length >= 8 ? id.substring(0, 8) : id}';
  }
}
