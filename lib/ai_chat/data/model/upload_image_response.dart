class UploadImageResponse {
  const UploadImageResponse({required this.file});

  factory UploadImageResponse.fromJson(Map<String, Object?> json) {
    final data = _payload(json);
    return UploadImageResponse(file: UploadImageData.fromJson(data));
  }

  final UploadImageData file;

  static Map<String, Object?> _payload(Map<String, Object?> json) {
    final data = json['data'];
    if (data is Map<String, Object?>) return data;

    final result = json['result'];
    if (result is Map<String, Object?>) {
      final nestedData = result['data'];
      if (nestedData is Map<String, Object?>) return nestedData;
      return result;
    }

    return json;
  }
}

class UploadImageData {
  const UploadImageData({
    required this.id,
    required this.title,
    required this.storage,
    required this.fileNameDisk,
    required this.fileNameDownload,
    required this.link,
    required this.fileSize,
    required this.projectId,
  });

  factory UploadImageData.fromJson(Map<String, Object?> json) {
    return UploadImageData(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      storage: json['storage'] as String? ?? '',
      fileNameDisk: json['file_name_disk'] as String? ?? '',
      fileNameDownload: json['file_name_download'] as String? ?? '',
      link: json['link'] as String? ?? json['imageUrl'] as String? ?? '',
      fileSize: (json['file_size'] as num?)?.toInt() ?? 0,
      projectId: json['project_id'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String storage;
  final String fileNameDisk;
  final String fileNameDownload;
  final String link;
  final int fileSize;
  final String projectId;

  String get fullUrl {
    final trimmed = link.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'https://cdn.u-code.io/${trimmed.startsWith('/') ? trimmed.substring(1) : trimmed}';
  }
}
