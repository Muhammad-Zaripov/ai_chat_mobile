class SendChatMessageResponse {
  const SendChatMessageResponse({required this.reply});

  factory SendChatMessageResponse.fromJson(Map<String, Object?> json) {
    return SendChatMessageResponse(reply: json['reply'] as String? ?? '');
  }

  final String reply;
}
