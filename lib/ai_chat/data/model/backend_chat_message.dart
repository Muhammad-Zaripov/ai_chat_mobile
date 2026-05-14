import 'package:ai_chat/ai_chat/domain/models/chat_message.dart';

class BackendChatMessage {
  const BackendChatMessage({
    required this.id,
    required this.chatId,
    required this.createdAt,
    required this.role,
    required this.content,
  });

  factory BackendChatMessage.fromJson(Map<String, Object?> json) {
    final message = json['message'];
    final body = message is Map ? message.cast<String, Object?>() : null;
    final role = body?['role'] as String? ?? '';
    final content = body?['content'] as String? ?? '';

    return BackendChatMessage(
      id: json['id'] as String? ?? '',
      chatId: json['chat_id'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      role: role,
      content: content,
    );
  }

  final String id;
  final String chatId;
  final DateTime createdAt;
  final String role;
  final String content;

  ChatMessage toDomain() {
    return ChatMessage(
      id: id,
      createdAt: createdAt,
      text: content,
      isMine: role == 'user',
    );
  }
}
