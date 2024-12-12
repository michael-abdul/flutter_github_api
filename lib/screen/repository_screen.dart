import 'package:flutter/material.dart';
import 'package:github_api_integration/model/repository.dart';
import 'package:github_api_integration/screen/code_list_screen.dart';
import 'package:github_api_integration/service/github_service.dart';

class RepositoryScreen extends StatefulWidget {
  final String username;

  RepositoryScreen({required this.username});

  @override
  _RepositoryScreenState createState() => _RepositoryScreenState();
}

class _RepositoryScreenState extends State<RepositoryScreen> {
  final GitHubService _githubService = GitHubService();
  List<Repository> _repositories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRepositories();
  }

  Future<void> _loadRepositories() async {
    try {
      final repositories = await _githubService.fetchRepositories(widget.username);
      setState(() {
        _repositories = repositories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load repositories: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username} Repositories'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _repositories.isEmpty
              ? Center(child: Text('No repositories found'))
              : ListView.builder(
                  itemCount: _repositories.length,
                  itemBuilder: (context, index) {
                    final repo = _repositories[index];
                    return ListTile(
                      title: Text(repo.name),
                      subtitle: Text(repo.owner),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                           builder: (_) => CodeListScreen(
                              owner: repo.owner,
                              repoName: repo.name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
