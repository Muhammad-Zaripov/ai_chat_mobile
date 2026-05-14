import 'dart:io';

import 'package:ai_chat/ai_chat/data/model/upload_image_request.dart';
import 'package:ai_chat/ai_chat/data/model/upload_image_response.dart';
import 'package:dio/dio.dart';

class ChatUploadService {
  ChatUploadService({Dio? dio}) : _dio = dio ?? sharedDio;

  static final Dio sharedDio = Dio();

  static const String _uploadPath = '/v1/files/folder_upload';
  static const String _defaultBaseUrl = String.fromEnvironment(
    'UPLOAD_BASE_URL',
    defaultValue: String.fromEnvironment('API_BASE_URL'),
  );
  static const String _authToken = String.fromEnvironment('UPLOAD_AUTH_TOKEN');

  final Dio _dio;

  Future<String> uploadImage(File file) async {
    if (_defaultBaseUrl.trim().isEmpty) {
      throw const ChatUploadException(
        'UPLOAD_BASE_URL yoki API_BASE_URL berilmagan',
      );
    }

    final formData = await UploadImageRequest(image: file).toFormData();
    final response = await _dio.post<Object?>(
      _uploadUrl,
      data: formData,
      queryParameters: const {'folder_name': 'Media'},
      options: Options(
        headers: {
          if (_authToken.isNotEmpty)
            HttpHeaders.authorizationHeader: _authToken,
        },
      ),
    );

    final json = response.data;
    if (json is! Map<String, Object?>) {
      throw const ChatUploadException('Upload response JSON object emas');
    }

    final uploadedFile = UploadImageResponse.fromJson(json).file;
    final url = uploadedFile.fullUrl.trim();
    if (url.isEmpty || url == 'https://cdn.u-code.io/') {
      throw const ChatUploadException('Upload response ichida url topilmadi');
    }

    return url;
  }

  String get _uploadUrl {
    final baseUrl = _defaultBaseUrl.trim();
    if (baseUrl.endsWith('/') && _uploadPath.startsWith('/')) {
      return '${baseUrl.substring(0, baseUrl.length - 1)}$_uploadPath';
    }
    if (!baseUrl.endsWith('/') && !_uploadPath.startsWith('/')) {
      return '$baseUrl/$_uploadPath';
    }
    return '$baseUrl$_uploadPath';
  }
}

class ChatUploadException implements Exception {
  const ChatUploadException(this.message);

  final String message;

  @override
  String toString() => message;
}
