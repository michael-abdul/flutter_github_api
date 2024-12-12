import 'package:flutter/material.dart';
import 'package:github_api_integration/model/issue.dart';
import 'package:github_api_integration/service/github_service.dart';
class IssuesScreen extends StatefulWidget {
  final String owner;
  final String repoName;

  IssuesScreen({required this.owner, required this.repoName});

  @override
  _IssuesScreenState createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  final GitHubService _githubService = GitHubService();
  List<Issue> _issues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIssues();
  }

  Future<void> _loadIssues() async {
    try {
      final issues = await _githubService.fetchIssues(widget.owner, widget.repoName);
      setState(() {
        _issues = issues;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load issues: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.repoName} Issues'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _issues.isEmpty
              ? Center(child: Text('No issues found'))
              : ListView.builder(
                  itemCount: _issues.length,
                  itemBuilder: (context, index) {
                    final issue = _issues[index];
                    return ListTile(
                      title: Text(issue.title),
                      subtitle: Text(issue.state),
                      isThreeLine: true,
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Issues details yoki boshqa harakatlarni qo'shing
                      },
                    );
                  },
                ),
    );
  }
}
