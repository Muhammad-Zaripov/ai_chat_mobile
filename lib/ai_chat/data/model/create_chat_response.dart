class CreateChatResponse {
  const CreateChatResponse({required this.id});

  factory CreateChatResponse.fromJson(Map<String, Object?> json) {
    return CreateChatResponse(id: json['id'] as String? ?? '');
  }

  final String id;
}
