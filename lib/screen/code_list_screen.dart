import 'package:flutter/material.dart';
import 'package:github_api_integration/model/code_content.dart';
import 'package:github_api_integration/screen/code_view_screen.dart';
import 'package:github_api_integration/service/github_service.dart';

class CodeListScreen extends StatefulWidget {
  final String owner;
  final String repoName;

  const CodeListScreen({super.key, required this.owner, required this.repoName});

  @override
  _CodeListScreenState createState() => _CodeListScreenState();
}

class _CodeListScreenState extends State<CodeListScreen> {
  final GitHubService _githubService = GitHubService();
  List<CodeContent> _contents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRepositoryContents();
  }

  Future<void> _loadRepositoryContents() async {
    try {
      final contents = await _githubService.fetchRepositoryContents(
          widget.owner, widget.repoName);
      setState(() {
        _contents = contents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load contents: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.repoName} Contents'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contents.isEmpty
              ? const Center(child: Text('No contents found'))
              : ListView.builder(
                  itemCount: _contents.length,
                  itemBuilder: (context, index) {
                    final item = _contents[index];
                    final isFile = item.type == 'file';
                    return ListTile(
                      leading:
                          Icon(isFile ? Icons.insert_drive_file : Icons.folder),
                      title: Text(item.name),
                      subtitle: isFile ? Text('${item.size} bytes') : null,
                      onTap: () {
                        if (!isFile) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CodeViewScreen(
                                fileName: item.name,
                                fileUrl: item.downloadUrl!,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('File: ${item.name} clicked')),
                          );
                        }
                      },
                    );
                  },
                ),
    );
  }
}
