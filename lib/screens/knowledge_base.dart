import 'package:flutter/material.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  // State variables
  List<String> knowledgeBases = [
    'Knowledge 1',
    'Knowledge 2',
    'Knowledge 3'
  ]; // Example data
  final TextEditingController _knowledgeNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Base Management'),
      ),
      body: Column(
        children: [
          // Add Knowledge Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _knowledgeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Knowledge Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add new knowledge base
                    if (_knowledgeNameController.text.isNotEmpty) {
                      setState(() {
                        knowledgeBases.add(_knowledgeNameController.text);
                      });
                      _knowledgeNameController.clear();
                    }
                  },
                  child: const Text('Add Knowledge'),
                ),
              ],
            ),
          ),
          const Divider(),

          // List of Knowledge Bases
          Expanded(
            child: ListView.builder(
              itemCount: knowledgeBases.length,
              itemBuilder: (context, index) {
                final knowledgeName = knowledgeBases[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(knowledgeName),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Delete') {
                          setState(() {
                            knowledgeBases.removeAt(index);
                          });
                        } else if (value == 'Upload') {
                          _showUploadOptions(knowledgeName);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: 'Delete', child: Text('Delete')),
                        const PopupMenuItem(
                            value: 'Upload', child: Text('Upload Data')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Show Upload Options Dialog
  void _showUploadOptions(String knowledgeName) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Upload from File'),
              onTap: () {
                Navigator.pop(context);
                _uploadFromFile(knowledgeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Upload from URL'),
              onTap: () {
                Navigator.pop(context);
                _uploadFromURL(knowledgeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: const Text('Upload from Google Drive'),
              onTap: () {
                Navigator.pop(context);
                _uploadFromGoogleDrive(knowledgeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Upload from Slack'),
              onTap: () {
                Navigator.pop(context);
                _uploadFromSlack(knowledgeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_tree),
              title: const Text('Upload from Confluence'),
              onTap: () {
                Navigator.pop(context);
                _uploadFromConfluence(knowledgeName);
              },
            ),
          ],
        );
      },
    );
  }

  // Placeholder methods for upload actions
  void _uploadFromFile(String knowledgeName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload from File to $knowledgeName'),
          content:
              const Text('File upload functionality is not yet implemented.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _uploadFromURL(String knowledgeName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload from URL to $knowledgeName'),
          content:
              const Text('URL upload functionality is not yet implemented.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _uploadFromGoogleDrive(String knowledgeName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload from Google Drive to $knowledgeName'),
          content: const Text(
              'Google Drive upload functionality is not yet implemented.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _uploadFromSlack(String knowledgeName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload from Slack to $knowledgeName'),
          content:
              const Text('Slack upload functionality is not yet implemented.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _uploadFromConfluence(String knowledgeName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload from Confluence to $knowledgeName'),
          content: const Text(
              'Confluence upload functionality is not yet implemented.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
