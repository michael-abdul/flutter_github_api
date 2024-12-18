import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_api_integration/model/code_content.dart';
import 'package:github_api_integration/model/code_view.dart';
import 'package:github_api_integration/model/repository.dart';
import 'package:github_api_integration/model/user.dart';
import 'package:http/http.dart' as http;
class GitHubService {
 final String baseUrl = dotenv.env['GITHUB_BASE_URL'] ?? '';
  final String token = dotenv.env['GITHUB_TOKEN'] ?? ''; // Agar token kerak bo'lsa

  Map<String, String> get headers => {
        'Accept': 'application/vnd.github+json',
        if (token.isNotEmpty) 'Authorization': 'token $token',
      };

  Future<User> fetchUser(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$username'), headers: headers);
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user: ${response.reasonPhrase}');
    }
  }

  Future<List<Repository>> fetchRepositories(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$username/repos'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Repository.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repositories: ${response.reasonPhrase}');
    }
  }

Future<List<CodeContent>> fetchRepositoryContents(String owner, String repo) async {
  final response = await http.get(Uri.parse('$baseUrl/repos/$owner/$repo/contents'),headers: headers);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => CodeContent.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load repository contents: ${response.reasonPhrase}');
  }
}


Future<CodeViewModel> fetchFileContent(String fileName, String fileUrl) async {
  final response = await http.get(
    Uri.parse(fileUrl),headers: headers);

  if (response.statusCode == 200) {
    return CodeViewModel.fromJson(fileName, response.body);
  } else {
    throw Exception('Failed to load file content: ${response.reasonPhrase}');
  }

 }

Future<void> monitorNewComments(String owner, String repo, int issueNumber) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/repos/$owner/$repo/issues/$issueNumber/comments'),
       headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> comments = json.decode(response.body);

      if (comments.isNotEmpty) {
        for (var comment in comments) {
          final user = comment['user']['login'];
          final body = comment['body'];

          final message = 'New comment in $repo by $user: $body';
          print(message);
          await sendMessageToSlack(message); // Slack’ga xabar yuborish
        }
      } else {
        print('No new comments found.');
      }
    } else {
      throw Exception('Failed to fetch comments: ${response.reasonPhrase}');
    }
  } catch (error) {
    print('Error monitoring comments: $error');
  }
}
Future<void> sendMessageToSlack(String text) async {
  final webhookUrl = dotenv.env['SLACK_WEBHOOK_URL'] ?? '';
  if (webhookUrl.isEmpty) {
    throw Exception('Slack Webhook URL not configured');
  }

  final response = await http.post(
    Uri.parse(webhookUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'text': text}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to send message to Slack: ${response.reasonPhrase}');
  }
}


}

