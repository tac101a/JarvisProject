import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jarvis_project/components/error_modal.dart';
import 'package:jarvis_project/models/prompt_model.dart';
import 'package:jarvis_project/services/prompt_service.dart';

import '../components/search_bar.dart';

class PromptScreen extends StatefulWidget {
  final Function(int, {String text}) onIconTap;

  const PromptScreen({super.key, required this.onIconTap});

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
  TextEditingController promptController = TextEditingController();
  TextEditingController searchBarController = TextEditingController();
  bool isLoading = true;
  int _selectedCategory = 0;

  // categories
  final List<String> _categories = [
    'All',
    'business',
    'career',
    'chatbot',
    'coding',
    'education',
    'fun',
    'marketing',
    'productivity',
    'seo',
    'writing',
    'other'
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
    promptController.dispose();
    searchBarController.dispose();
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
      if (response) {
        print("Added to favorite");
      }
    } catch (e) {
      showErrorModal(context, e.toString());
      print(e);
    }
  }

  // remove from favorite
  Future<void> _removeFromFavorites(String promptID) async {
    try {
      var response = await _promptService.removeFromFavorite(promptID);
      if (response) {
        print("Removed from favorite");
      }
    } catch (e) {
      showErrorModal(context, e.toString());
      print(e);
    }
  }

  Future<void> _createPrompt(String prompt, {bool isPublic = false}) async {
    // // TODO: Replace this with actual API call to create a new prompt
    // setState(() {
    //   prompts.add(prompt);
    // });
  }

  Future<void> _updatePrompt(int index, String newPrompt) async {
    // // TODO: Replace this with actual API call to update a prompt
    // setState(() {
    //   prompts[index] = newPrompt;
    // });
  }

  Future<void> _deletePrompt(int index) async {
    // // TODO: Replace this with actual API call to delete a prompt
    // setState(() {
    //   prompts.removeAt(index);
    // });
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
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final prompt = prompts[index];

              return ListTile(
                title: Text(prompt.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // edit button
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Edit prompt
                        showDialog(
                          context: context,
                          builder: (context) {
                            promptController.text = prompt.title;
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
                    // delete button
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Delete prompt
                        _deletePrompt(index);
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
                  widget.onIconTap(0, text: prompt.content);
                },
              );
            },
          ))
      ],
    );
  }
}
