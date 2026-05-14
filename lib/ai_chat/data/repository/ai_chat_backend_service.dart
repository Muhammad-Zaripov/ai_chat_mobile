import 'dart:io';
import 'package:ai_chat/ai_chat/data/model/backend_chat_message.dart';
import 'package:ai_chat/ai_chat/data/model/chat_summary.dart';
import 'package:ai_chat/ai_chat/data/model/create_chat_response.dart';
import 'package:ai_chat/ai_chat/data/model/send_chat_message_response.dart';
import 'package:ai_chat/ai_chat/domain/models/chat_message.dart';
import 'package:ai_chat/core/network/app_dio.dart';
import 'package:dio/dio.dart';

class AiChatBackendService {
  AiChatBackendService({Dio? dio}) : _dio = dio ?? appDio;

  static const String _defaultBaseUrl = String.fromEnvironment(
    'AI_CHAT_BASE_URL',
    defaultValue: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://ai-chat.leetcoders.uz',
    ),
  );
  static const String _model = String.fromEnvironment('OPENAI_MODEL');
  static const String _authToken = String.fromEnvironment('AI_CHAT_AUTH_TOKEN');

  final Dio _dio;
  String? _chatId;

  String? get currentChatId => _chatId;

  set currentChatId(String? value) {
    final trimmed = value?.trim();
    _chatId = trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  Future<List<ChatSummary>> listChats() async {
    final response = await _get(_joinUrl(_defaultBaseUrl, '/v1/chats'));
    final json = response.data;
    if (json is! Map<String, Object?>) {
      throw const AiChatBackendException('Chat list response JSON object emas');
    }

    final items = json['items'];
    if (items is! List) return const <ChatSummary>[];

    return items
        .whereType<Map>()
        .map((item) => ChatSummary.fromJson(item.cast<String, Object?>()))
        .where((chat) => chat.id.trim().isNotEmpty)
        .toList(growable: false);
  }

  Future<List<ChatMessage>> listMessages(String chatId) async {
    final id = chatId.trim();
    if (id.isEmpty) return const <ChatMessage>[];

    final response = await _get(
      _joinUrl(_defaultBaseUrl, '/v1/chats/$id/messages'),
    );
    final json = response.data;
    if (json is! Map<String, Object?>) {
      throw const AiChatBackendException(
        'Messages list response JSON object emas',
      );
    }

    final items = json['items'];
    if (items is! List) return const <ChatMessage>[];

    return items
        .whereType<Map>()
        .map(
          (item) => BackendChatMessage.fromJson(item.cast<String, Object?>()),
        )
        .where((message) => message.content.trim().isNotEmpty)
        .map((message) => message.toDomain())
        .toList(growable: false);
  }

  Future<String> createChat() async {
    final chatId = await _createChat();
    _chatId = chatId;
    return chatId;
  }

  Future<String> sendMessage({required String text}) async {
    final chatId = _chatId ?? await _createChat();
    _chatId = chatId;

    final response = await _post(
      _joinUrl(_defaultBaseUrl, '/v1/chats/$chatId/messages'),
      data: {'input': text.trim().isEmpty ? 'Rasm yuborildi.' : text.trim()},
    );

    final json = response.data;
    if (json is! Map<String, Object?>) {
      throw const AiChatBackendException('AI chat response JSON object emas');
    }

    return SendChatMessageResponse.fromJson(json).reply;
  }

  Future<String> _createChat() async {
    final response = await _post(
      _joinUrl(_defaultBaseUrl, '/v1/chats'),
      data: {if (_model.trim().isNotEmpty) 'model': _model.trim()},
    );

    final json = response.data;
    if (json is! Map<String, Object?>) {
      throw const AiChatBackendException(
        'Create chat response JSON object emas',
      );
    }

    final chatId = CreateChatResponse.fromJson(json).id.trim();
    if (chatId.isEmpty) {
      throw const AiChatBackendException('Create chat response ichida id yo‘q');
    }

    return chatId;
  }

  Map<String, String> get _headers {
    return {
      if (_authToken.isNotEmpty) HttpHeaders.authorizationHeader: _authToken,
    };
  }

  Future<Response<Object?>> _post(
    String url, {
    required Map<String, Object?> data,
  }) async {
    try {
      return await _dio.post<Object?>(
        url,
        data: data,
        options: Options(headers: _headers),
      );
    } on DioException catch (error) {
      throw AiChatBackendException(_formatDioError(error));
    }
  }

  Future<void> deleteChat(String chatId) async {
    final id = chatId.trim();
    if (id.isEmpty) return;
    await _delete(_joinUrl(_defaultBaseUrl, '/v1/chats/$id'));
    if (_chatId == id) _chatId = null;
  }

  Future<void> deleteAllChats() async {
    await _delete(_joinUrl(_defaultBaseUrl, '/v1/chats'));
    _chatId = null;
  }

  Future<Response<Object?>> _get(String url) async {
    try {
      return await _dio.get<Object?>(url, options: Options(headers: _headers));
    } on DioException catch (error) {
      throw AiChatBackendException(_formatDioError(error));
    }
  }

  Future<Response<Object?>> _delete(String url) async {
    try {
      return await _dio.delete<Object?>(url, options: Options(headers: _headers));
    } on DioException catch (error) {
      throw AiChatBackendException(_formatDioError(error));
    }
  }

  String _joinUrl(String baseUrl, String path) {
    final trimmedBase = baseUrl.trim();
    if (trimmedBase.endsWith('/') && path.startsWith('/')) {
      return '${trimmedBase.substring(0, trimmedBase.length - 1)}$path';
    }
    if (!trimmedBase.endsWith('/') && !path.startsWith('/')) {
      return '$trimmedBase/$path';
    }
    return '$trimmedBase$path';
  }

  String _formatDioError(DioException error) {
    final response = error.response;
    if (response != null) {
      final data = response.data;
      if (data is Map && data['error'] != null) {
        return 'HTTP ${response.statusCode}: ${data['error']}';
      }
      return 'HTTP ${response.statusCode}: $data';
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout =>
        'connection timeout: $_defaultBaseUrl',
      DioExceptionType.receiveTimeout => 'receive timeout: $_defaultBaseUrl',
      DioExceptionType.sendTimeout => 'send timeout: $_defaultBaseUrl',
      DioExceptionType.connectionError => 'connection error: ${error.message}',
      _ => error.message ?? error.toString(),
    };
  }
}

class AiChatBackendException implements Exception {
  const AiChatBackendException(this.message);

  final String message;

  @override
  String toString() => message;
}
