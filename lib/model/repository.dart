class Repository {
  final String name;
  final String owner;
  final String url;

  Repository({required this.name, required this.owner, required this.url});

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      owner: json['owner']['login'],
      url: json['html_url'],
    );
  }
}
