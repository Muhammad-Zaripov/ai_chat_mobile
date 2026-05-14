import 'dart:io';

import 'package:ai_chat/ai_chat/data/model/create_chat_response.dart';
import 'package:ai_chat/ai_chat/data/model/send_chat_message_response.dart';
import 'package:ai_chat/ai_chat/data/repository/chat_upload_service.dart';
import 'package:dio/dio.dart';

class AiChatBackendService {
  AiChatBackendService({Dio? dio}) : _dio = dio ?? ChatUploadService.sharedDio;

  static const String _defaultBaseUrl = String.fromEnvironment(
    'AI_CHAT_BASE_URL',
    defaultValue: String.fromEnvironment('API_BASE_URL'),
  );
  static const String _model = String.fromEnvironment('OPENAI_MODEL');
  static const String _authToken = String.fromEnvironment('AI_CHAT_AUTH_TOKEN');

  final Dio _dio;
  String? _chatId;

  Future<String> sendMessage({
    required String text,
    required String? imageUrl,
  }) async {
    if (_defaultBaseUrl.trim().isEmpty) {
      throw const AiChatBackendException(
        'AI_CHAT_BASE_URL yoki API_BASE_URL berilmagan',
      );
    }

    final chatId = _chatId ?? await _createChat();
    _chatId = chatId;

    final response = await _post(
      _joinUrl(_defaultBaseUrl, '/v1/chats/$chatId/messages'),
      data: {'input': _buildInput(text: text, imageUrl: imageUrl)},
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

  String _buildInput({required String text, required String? imageUrl}) {
    final parts = <String>[
      if (text.trim().isNotEmpty) text.trim(),
      if (imageUrl != null && imageUrl.trim().isNotEmpty)
        'User attached image/file URL: ${imageUrl.trim()}',
    ];
    return parts.join('\n\n');
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
