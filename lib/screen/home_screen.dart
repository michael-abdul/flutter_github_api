import 'package:flutter/material.dart';
import 'package:github_api_integration/screen/user_screen.dart';


class HomeScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Integration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Enter GitHub Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final username = _usernameController.text.trim();
                if (username.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserScreen(username: username),
                    ),
                  );
                }
              },
              child: const Text('Search User'),
            ),
          ],
        ),
      ),
    );
  }
}
