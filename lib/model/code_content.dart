class CodeContent {
  final String name;
  final String path;
  final String type;
  final int? size;
  final String? downloadUrl;

  CodeContent({
    required this.name,
    required this.path,
    required this.type,
    this.size,
    this.downloadUrl,
  });

  factory CodeContent.fromJson(Map<String, dynamic> json) {
    return CodeContent(
      name: json['name'],
      path: json['path'],
      type: json['type'],
      size: json['size'],
      downloadUrl: json['download_url'],
    );
  }
}
