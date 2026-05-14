class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.createdAt,
    this.text,
    this.isMine = true,
  });

  final String id;
  final DateTime createdAt;
  final String? text;
  final bool isMine;

  bool get hasText => text != null && text!.trim().isNotEmpty;
}
