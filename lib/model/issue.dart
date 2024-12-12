class Issue {
  final String title;
  final String body;
  final String state;

  Issue({required this.title, required this.body, required this.state});

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      title: json['title'],
      body: json['body'] ?? '',
      state: json['state'],
    );
  }
}
