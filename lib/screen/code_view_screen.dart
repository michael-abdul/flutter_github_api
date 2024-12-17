import 'package:flutter/material.dart';
import 'package:github_api_integration/model/code_view.dart';
import 'package:github_api_integration/service/github_service.dart';

class CodeViewScreen extends StatefulWidget {
  final String fileName;
  final String fileUrl;

  const CodeViewScreen({super.key, required this.fileName, required this.fileUrl});

  @override
  _CodeViewScreenState createState() => _CodeViewScreenState();
}

class _CodeViewScreenState extends State<CodeViewScreen> {
  final GitHubService _githubService = GitHubService();
  CodeViewModel? _codeViewModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFileContent();
  }

  Future<void> _loadFileContent() async {
    try {
      final content = await _githubService.fetchFileContent(
        widget.fileName,
        widget.fileUrl,
      );
      setState(() {
        _codeViewModel = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _codeViewModel == null
              ? const Center(child: Text('No content available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectableText(
                    _codeViewModel!.content,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                  ),
                ),
    );
  }
}
