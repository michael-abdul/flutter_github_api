class CodeViewModel {
  final String fileName;
  final String content;

  CodeViewModel({
    required this.fileName,
    required this.content,
  });

  factory CodeViewModel.fromJson(String fileName, String content) {
    return CodeViewModel(
      fileName: fileName,
      content: content,
    );
  }
}
