import 'dart:io';

import 'package:dio/dio.dart';

class UploadImageRequest {
  UploadImageRequest({required this.image});

  final File image;

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'file': await MultipartFile.fromFile(
        image.path,
        filename: image.path.split(Platform.pathSeparator).last,
      ),
    });
  }
}
