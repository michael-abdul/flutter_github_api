import 'package:github_api_integration/model/user.dart';

class Issue {
  final String title;
  final String body;
  final String state;
  final User? user; // Yangi user maydoni

  Issue({
    required this.title,
    required this.body,
    required this.state,
    this.user,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      state: json['state'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
