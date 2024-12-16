import 'dart:convert';
import 'dart:io';

import 'package:github_api_integration/service/github_service.dart';

void startServer() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Server started on http://localhost:8080');
  final GitHubService _githubService = GitHubService();
  await for (HttpRequest request in server) {
    if (request.method == 'POST' && request.uri.path == '/monitor') {
      // Request body'ni o‘qib olish
      final content = await utf8.decoder.bind(request).join();
      final data = json.decode(content);

      final owner = data['owner'];
      final repo = data['repo'];
      final issueNumber = data['issueNumber'];

      try {
        await _githubService.monitorNewComments(owner, repo, issueNumber);
        request.response
          ..statusCode = HttpStatus.ok
          ..write('Monitoring new comments for $repo...');
      } catch (error) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write('Error: $error');
      }
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Endpoint not found');
    }

    await request.response.close();
  }
}
