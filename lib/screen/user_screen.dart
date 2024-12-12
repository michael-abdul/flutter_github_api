import 'package:flutter/material.dart';
import 'package:github_api_integration/model/user.dart';
import 'package:github_api_integration/service/github_service.dart';
import 'repository_screen.dart';

class UserScreen extends StatefulWidget {
  final String username;

  UserScreen({required this.username});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final GitHubService _githubService = GitHubService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _githubService.fetchUser(widget.username);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
              ? Center(child: Text('User not found'))
              : Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(_user!.avatarUrl),
                      ),
                      title: Text(_user!.username),
                      subtitle: Text(_user!.bio),
                    ),
                    ListTile(
                      title: Text('Followers: ${_user!.followers}'),
                      subtitle: Text('Following: ${_user!.following}'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RepositoryScreen(username: _user!.username),
                          ),
                        );
                      },
                      child: Text('View Repositories'),
                    ),
                  ],
                ),
    );
  }
}
