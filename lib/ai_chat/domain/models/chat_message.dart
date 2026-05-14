class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.createdAt,
    this.text,
    this.imagePath,
    this.imageUrl,
    this.isMine = true,
  });

  final String id;
  final DateTime createdAt;
  final String? text;
  final String? imagePath;
  final String? imageUrl;
  final bool isMine;

  bool get hasText => text != null && text!.trim().isNotEmpty;

  bool get hasImage =>
      (imagePath != null && imagePath!.trim().isNotEmpty) ||
      (imageUrl != null && imageUrl!.trim().isNotEmpty);
}
