import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jarvis_project/components/error_modal.dart';
import 'package:jarvis_project/models/prompt_model.dart';
import 'package:jarvis_project/services/prompt_service.dart';
import 'package:jarvis_project/style/styles.dart';

import '../components/search_bar.dart';

class PromptScreen extends StatefulWidget {
  final Function(int, {String text}) onPromptSelect;

  const PromptScreen({super.key, required this.onPromptSelect});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  // service
  final PromptService _promptService = PromptService();

  // State variables
  bool showPublicPrompts = true;
  bool showFavorites = false;
  List<dynamic> prompts = []; // This will store fetched prompts
  bool isLoading = true;
  int _selectedCategory = 0;
  String createPromptScope = 'private';
  String _selectedLanguage = 'English';
  String _createPromptCategory = 'Other';

  // text field controller
  TextEditingController searchBarController = TextEditingController();
  TextEditingController dialogNameController = TextEditingController();
  TextEditingController dialogDescriptionController = TextEditingController();
  TextEditingController dialogContentController = TextEditingController();

  // categories
  final List<String> _categories = [
    'All',
    'Business',
    'Career',
    'Chatbot',
    'Coding',
    'Education',
    'Fun',
    'Marketing',
    'Productivity',
    'Seo',
    'Writing',
    'Other'
  ];

  // languages
  final List<String> _languages = [
    'English',
    'Vietnamese',
    'French',
    'Spanish',
    'Japanese',
    'German',
    'Chinese',
    'Korean',
    'Italian',
    'Russian',
    'Arabic',
    'Portuguese',
    'Hindi',
    'Bengali'
  ];

  // init
  @override
  void initState() {
    super.initState();
    _fetchPrompts();
  }

  // dispose
  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
    dialogNameController.dispose();
    dialogDescriptionController.dispose();
    dialogContentController.dispose();
  }

  void resetDialogState() {
    setState(() {
      createPromptScope = 'private';
      _selectedLanguage = 'English';
      _createPromptCategory = 'Other';
      dialogNameController.text = '';
      dialogDescriptionController.text = '';
      dialogContentController.text = '';
    });
  }

  // get prompts
  Future<void> _fetchPrompts({String? query}) async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await _promptService.getPrompt(
          query: query,
          category: _categories[_selectedCategory] == 'All'
              ? null
              : _categories[_selectedCategory],
          isPublic: showPublicPrompts ? null : showPublicPrompts,
          isFavorite: showFavorites ? showFavorites : null);
      var data = json.decode(response);

      List<dynamic> temp = [];
      for (var item in data['items']) {
        temp.add(Prompt(
            item['_id'],
            item['category'] ?? '',
            item['content'] ?? '',
            item['description'] ?? '',
            item['title'] ?? '',
            item['isPublic'],
            item['isFavorite']));
      }

      setState(() {
        prompts = temp;
        isLoading = false;
      });
    } catch (e) {
      showErrorModal(context, e.toString());
      print(e);
    }
  }

  // add to favorite
  Future<void> _addToFavorites(String promptID) async {
    try {
      var response = await _promptService.addToFavorite(promptID);
      if (response) {}
    } catch (e) {
      showErrorModal(context, e.toString());
    }
  }

  // remove from favorite
  Future<void> _removeFromFavorites(String promptID) async {
    try {
      var response = await _promptService.removeFromFavorite(promptID);
      if (response) {}
    } catch (e) {
      showErrorModal(context, e.toString());
    }
  }

  Future<void> _createPrompt() async {
    var res = await _promptService.createPrompt(
        title: dialogNameController.text,
        language: _selectedLanguage,
        category: _createPromptCategory,
        isPublic: createPromptScope == 'public',
        description: dialogDescriptionController.text,
        content: dialogContentController.text);

    if (res) {
      _fetchPrompts();
    }
  }

  Future<void> _updatePrompt(String id) async {
    var res = await _promptService.updatePrompt(id,
        title: dialogNameController.text,
        language: _selectedLanguage,
        category: _createPromptCategory,
        isPublic: createPromptScope == 'public',
        description: dialogDescriptionController.text,
        content: dialogContentController.text);

    if (res) {
      _fetchPrompts();
    }
  }

  Future<void> _deletePrompt(String id) async {
    var res = await _promptService.deletePrompt(id);

    if (res) {
      _fetchPrompts();
    }
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
              _fetchPrompts();
            },
          ),
          IconButton(
            icon: Icon(showFavorites ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                showFavorites = !showFavorites;
              });
              _fetchPrompts();
            },
          )
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new prompt
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return _buildDialog(context, setState, 'create');
              });
            },
          ).then((result) {
            resetDialogState();
          });
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
              onSubmitted: (value) {
                _fetchPrompts(query: value);
              }),
        ),

        // categories select
        Row(
          children: [
            Expanded(
                child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ChoiceChip(
                              label: Text(_categories[index]),
                              selected: _selectedCategory == index,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedCategory =
                                      selected ? index : _selectedCategory;
                                });
                                _fetchPrompts();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              selectedColor: Colors.black,
                              labelStyle: TextStyle(
                                  color: _selectedCategory == index
                                      ? Colors.white
                                      : Colors.black),
                              backgroundColor: Colors.grey[200],
                              showCheckmark: false,
                              side: BorderSide.none,
                            ),
                          );
                        }))),
          ],
        ),
        // when loading
        if (isLoading) const Center(child: CircularProgressIndicator()),

        // finish loading
        if (!isLoading && prompts.isEmpty) // if list is empty
          const Center(
              child: Text(
            'Empty list',
            style: TextStyle(color: Colors.grey),
          )),
        if (!isLoading && prompts.isNotEmpty)
          Flexible(
              child: ListView.separated(
            shrinkWrap: true,
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final prompt = prompts[index];

              return ListTile(
                title: Text(
                  prompt.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  prompt.description,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // edit button
                    if (!prompt.isPublic)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Edit prompt
                          setState(() {
                            createPromptScope =
                                prompt.isPublic ? 'public' : 'private';
                            _selectedLanguage = 'English';
                            _createPromptCategory =
                                prompt.category[0].toUpperCase() +
                                    prompt.category.substring(1);
                            dialogNameController.text = prompt.title;
                            dialogDescriptionController.text =
                                prompt.description;
                            dialogContentController.text = prompt.content;
                          });

                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return _buildDialog(context, setState, 'update',
                                    prompt: prompt);
                              });
                            },
                          ).then((result) {
                            resetDialogState();
                          });
                        },
                      ),
                    // delete button
                    if (!prompt.isPublic)
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
                                              WidgetStatePropertyAll(
                                                  Colors.red)),
                                      onPressed: () {
                                        _deletePrompt(prompt.id);
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
                    IconButton(
                      icon: prompt.isFavorite
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_border),
                      onPressed: () {
                        if (prompt.isFavorite) {
                          _removeFromFavorites(prompt.id);
                        } else {
                          _addToFavorites(prompt.id);
                        }
                        setState(() {
                          prompt.isFavorite = !prompt.isFavorite;
                        });
                      },
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return _buildDialog(context, setState, 'view',
                            prompt: prompt);
                      });
                    },
                  ).then((result) {
                    resetDialogState();
                  });
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
      ],
    );
  }

  Widget _buildDialog(BuildContext context, Function setState, String action,
      {Prompt? prompt}) {
    bool isViewing = action == 'view';

    String title = '';
    String submitText = '';
    Function onSubmit = () {};

    switch (action) {
      case 'create':
        title = 'New Prompt';
        dialogDescriptionController.text = '';
        dialogContentController.text = '';
        submitText = 'Create';
        onSubmit = _createPrompt;
        break;

      case 'update':
        title = 'Update Prompt';
        dialogDescriptionController.text = prompt!.description;
        dialogContentController.text = prompt.content;
        submitText = 'Update';
        onSubmit = () {
          _updatePrompt(prompt.id);
        };
        break;

      case 'view':
        title = prompt!.title;
        dialogDescriptionController.text = prompt.description;
        dialogContentController.text = prompt.content;
        submitText = 'Use prompt';
        onSubmit = () {
          widget.onPromptSelect(0, text: prompt.content);
        };
        break;
    }

    return AlertDialog(
      title: dialogTitle(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isViewing) ...[
                  // scope selection
                  Row(
                    children: [
                      Radio(
                        value: 'private',
                        groupValue: createPromptScope,
                        onChanged: (value) {
                          setState(() {
                            createPromptScope = value!;
                          });
                        },
                      ),
                      const Text(
                        'Private',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Radio(
                        value: 'public',
                        groupValue: createPromptScope,
                        onChanged: (value) {
                          setState(() {
                            createPromptScope = value!;
                          });
                        },
                      ),
                      const Text(
                        'Public',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Prompt Language',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: DropdownButton(
                        focusColor: Colors.transparent,
                        underline: Container(),
                        value: _selectedLanguage,
                        items: _languages.map((item) {
                          return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 12),
                              ));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLanguage = newValue!;
                          });
                        }),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Name',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    style: const TextStyle(fontSize: 12),
                    controller: dialogNameController,
                    decoration: dialogInputField('Name of the prompt'),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Category',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: DropdownButton(
                        focusColor: Colors.transparent,
                        underline: Container(),
                        value: _createPromptCategory,
                        items: _categories.sublist(1).map((item) {
                          return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 12),
                              ));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _createPromptCategory = newValue!;
                          });
                        }),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                ],
                TextField(
                  maxLines: isViewing ? null : 2,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  controller: dialogDescriptionController,
                  readOnly: isViewing,
                  enabled: !isViewing,
                  decoration: dialogInputField(
                      'Describe your prompt to others can have a better understanding'),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Prompt',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  maxLines: isViewing ? 10 : 3,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  controller: dialogContentController,
                  readOnly: isViewing,
                  decoration: dialogInputField(
                      'e.g: Write an article about [TOPIC] make sure to include these keyword: [KEYWORDS]'),
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
}
