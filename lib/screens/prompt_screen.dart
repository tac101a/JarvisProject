import 'package:flutter/material.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  // State variables
  bool showPublicPrompts = true;
  bool showFavorites = false;
  List<String> prompts = []; // This will store fetched prompts
  List<String> favoritePrompts = [];
  TextEditingController promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPrompts();
  }

  Future<void> _fetchPrompts(
      {bool isPublic = true, bool isFavorite = false}) async {
    // TODO: Replace this with actual API calls.
    setState(() {
      if (isPublic) {
        prompts = ['Public Prompt 1', 'Public Prompt 2', 'Public Prompt 3'];
      } else {
        prompts = ['Private Prompt 1', 'Private Prompt 2'];
      }
      if (isFavorite) {
        favoritePrompts = ['Favorite Prompt 1', 'Favorite Prompt 2'];
      }
    });
  }

  Future<void> _addToFavorites(String prompt) async {
    // TODO: Replace this with actual API call for adding to favorites
    setState(() {
      favoritePrompts.add(prompt);
    });
  }

  Future<void> _createPrompt(String prompt, {bool isPublic = false}) async {
    // TODO: Replace this with actual API call to create a new prompt
    setState(() {
      prompts.add(prompt);
    });
  }

  Future<void> _updatePrompt(int index, String newPrompt) async {
    // TODO: Replace this with actual API call to update a prompt
    setState(() {
      prompts[index] = newPrompt;
    });
  }

  Future<void> _deletePrompt(int index) async {
    // TODO: Replace this with actual API call to delete a prompt
    setState(() {
      prompts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Prompts'),
        actions: [
          IconButton(
            icon: Icon(showPublicPrompts ? Icons.public : Icons.lock),
            onPressed: () {
              setState(() {
                showPublicPrompts = !showPublicPrompts;
              });
              _fetchPrompts(isPublic: showPublicPrompts);
            },
          ),
          IconButton(
            icon: Icon(showFavorites ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                showFavorites = !showFavorites;
              });
              if (showFavorites) _fetchPrompts(isFavorite: true);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: showFavorites ? favoritePrompts.length : prompts.length,
        itemBuilder: (context, index) {
          final prompt =
              showFavorites ? favoritePrompts[index] : prompts[index];
          return ListTile(
            title: Text(prompt),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Edit prompt
                    showDialog(
                      context: context,
                      builder: (context) {
                        promptController.text = prompt;
                        return AlertDialog(
                          title: const Text('Edit Prompt'),
                          content: TextField(
                            controller: promptController,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _updatePrompt(index, promptController.text);
                                Navigator.pop(context);
                              },
                              child: const Text('Update'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Delete prompt
                    _deletePrompt(index);
                  },
                ),
                if (!showFavorites)
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      _addToFavorites(prompt);
                    },
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new prompt
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Create New Prompt'),
                content: TextField(
                  controller: promptController,
                  decoration: const InputDecoration(hintText: 'Enter prompt'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _createPrompt(promptController.text,
                          isPublic: showPublicPrompts);
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
