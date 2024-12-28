import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:jarvis_project/models/knowledge_model.dart';
import 'package:jarvis_project/services/knowledge_service.dart';

import '../components/error_modal.dart';
import '../components/search_bar.dart';
import '../style/styles.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  // service
  final KnowledgeService _knowledgeService = KnowledgeService();

  // State variables
  bool isLoading = true;
  List<dynamic> knowledgeList = [
    'Knowledge 1',
    'Knowledge 2',
    'Knowledge 3'
  ]; // Example data
  List<dynamic> showingList = [];

  // text controller
  final TextEditingController dialogNameController = TextEditingController();
  final TextEditingController dialogDescriptionController =
      TextEditingController();
  final TextEditingController searchBarController = TextEditingController();

  // init
  @override
  void initState() {
    super.initState();
    _getKnowledge();
    showingList = knowledgeList;
  }

  // dispose
  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
    dialogNameController.dispose();
    dialogDescriptionController.dispose();
  }

  Future<void> _getKnowledge() async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await _knowledgeService.getKnowledge();
      var data = json.decode(response);

      List<dynamic> temp = [];
      for (var item in data['data']) {
        temp.add(Knowledge(
            id: item['id'],
            name: item['knowledgeName'],
            description: item['description']));
      }

      setState(() {
        knowledgeList = temp;
        isLoading = false;

        showingList = knowledgeList;
      });
    } catch (e) {
      showErrorModal(context, e.toString());
      print(e);
    }
  }

  Future<void> _createKnowledge() async {
    var res = await _knowledgeService.createKnowledge(
        name: dialogNameController.text,
        description: dialogDescriptionController.text);

    if (res) {
      _getKnowledge();
    }
  }

  Future<void> _updateKnowledge(String id) async {
    var res = await _knowledgeService.updateKnowledge(
      id,
      name: dialogNameController.text,
      description: dialogDescriptionController.text,
    );

    if (res) {
      _getKnowledge();
    }
  }

  Future<void> _deleteKnowledge(String id) async {
    try {
      setState(() {
        isLoading = true;
      });
      var res = await _knowledgeService.deleteKnowledge(id);

      if (res) {
        _getKnowledge();
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Request failed');
      }
    } catch (e) {
      showErrorModal(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Base'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new bot
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return _buildDialog(context, setState, 'create');
              });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // search bar
        Padding(
          padding: const EdgeInsets.all(8),
          child: searchBar(
              controller: searchBarController,
              onChanged: (value) {
                var temp = knowledgeList.where((element) {
                  var name = element.name.toLowerCase();
                  var des = element.description.toLowerCase();
                  var q = value.toLowerCase();
                  return name.contains(q) || des.contains(q);
                }).toList();

                setState(() {
                  showingList = temp;
                });
              }),
        ),

        // when loading
        if (isLoading) const Center(child: CircularProgressIndicator()),

        // finish loading
        if (!isLoading && showingList.isEmpty) // if list is empty
          const Center(
              child: Text(
            'Empty list',
            style: TextStyle(color: Colors.grey),
          )),
        if (!isLoading && showingList.isNotEmpty) ...[
          Flexible(
              child: ListView.separated(
            shrinkWrap: true,
            itemCount: showingList.length,
            itemBuilder: (context, index) {
              final kb = showingList[index];

              return ListTile(
                title: Text(
                  kb.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  kb.description,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // edit button
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Edit prompt
                        setState(() {
                          dialogNameController.text = kb.name;
                          dialogDescriptionController.text = kb.description;
                        });

                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return _buildDialog(context, setState, 'update',
                                  knowledge: kb);
                            });
                          },
                        );
                      },
                    ),
                    // delete button
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: dialogTitle('Delete Prompt',
                                    color: Colors.red),
                                content: const Text(
                                  'Are you sure?',
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll(Colors.red)),
                                    onPressed: () {
                                      _deleteKnowledge(kb.id);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    // favorite button
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return _buildDialog(context, setState, 'view',
                            knowledge: kb);
                      });
                    },
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey.shade300,
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
              );
            },
          ))
        ]
      ],
    );
  }

  Widget _buildDialog(BuildContext context, Function setState, String action,
      {Knowledge? knowledge}) {
    bool isViewing = action == 'view';

    String title = '';
    String submitText = '';
    Function onSubmit = () {};

    switch (action) {
      case 'create':
        title = 'New Knowledge';
        dialogDescriptionController.text = '';
        dialogNameController.text = '';
        submitText = 'Create';
        onSubmit = _createKnowledge;
        break;

      case 'update':
        title = 'Update Knowledge';
        dialogDescriptionController.text = knowledge!.description;
        dialogNameController.text = knowledge.name;
        submitText = 'Update';
        onSubmit = () {
          _updateKnowledge(knowledge.id);
        };
        break;

      case 'view':
        title = knowledge!.name;
        dialogDescriptionController.text = knowledge.description;
        dialogNameController.text = knowledge.name;
        submitText = 'Use Knowledge';
        onSubmit = () {
          // widget.onPromptSelect(0, text: knowledge.content);
        };
        break;
    }

    return AlertDialog(
      title: dialogTitle(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isViewing) ...[
                  const Text(
                    'Name',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    style: const TextStyle(fontSize: 12),
                    controller: dialogNameController,
                    readOnly: isViewing,
                    enabled: !isViewing,
                    decoration: dialogInputField('Name of the knowledge'),
                  ),
                  const SizedBox(height: 16.0)
                ],
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  maxLines: isViewing ? 10 : 3,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  controller: dialogDescriptionController,
                  decoration: dialogInputField(
                      'e.g: This is the description of this knowledge'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.lightBlue[100])),
          onPressed: () {
            onSubmit();
            Navigator.pop(context);
          },
          child: Text(submitText),
        ),
      ],
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
