import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jarvis_project/models/assistant_model.dart';
import 'package:jarvis_project/services/assistant_service.dart';

import '../components/error_modal.dart';
import '../components/search_bar.dart';

class BotManagementScreen extends StatefulWidget {
  const BotManagementScreen({super.key});

  @override
  State<BotManagementScreen> createState() => _BotManagementScreenState();
}

class _BotManagementScreenState extends State<BotManagementScreen> {
  // service
  final AssistantService _assistantService = AssistantService();

  // util
  // Predefined bots (from assistant_model.dart)
  final List<dynamic> builtinBots = botID.keys.toList().map((element) {
    return Assistant(id: element, name: botID[element]!);
  }).toList();

  // User-created bots
  List<dynamic> customBots = [];

  // state
  int _selectedType = 0;
  bool isLoading = true;
  List<dynamic> showingList = [];

  // Text controller for creating a new bot
  final TextEditingController searchBarController = TextEditingController();

  final List<String> _assistantType = ['Built-in', 'Custom'];

  // init
  @override
  void initState() {
    super.initState();
    _getBots();
    showingList = builtinBots;
  }

  // dispose
  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
  }

  Future<void> _getBots({String? query}) async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await _assistantService.getAssistant();
      var data = json.decode(response);

      List<dynamic> temp = [];
      for (var item in data['data']) {
        temp.add(Assistant(
            id: item['id'],
            name: item['assistantName'],
            instructions: item['instructions'],
            description: item['description']));
      }

      setState(() {
        customBots = temp;
        isLoading = false;
      });
    } catch (e) {
      showErrorModal(context, e.toString());
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistants Library'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new bot
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
                var list = _selectedType == 0 ? builtinBots : customBots;
                var temp = list.where((element) {
                  var name = element.name.toLowerCase();
                  var q = value.toLowerCase();
                  return name.contains(q);
                }).toList();

                setState(() {
                  showingList = temp;
                });
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
                        itemCount: _assistantType.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ChoiceChip(
                              label: Text(_assistantType[index]),
                              selected: _selectedType == index,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedType =
                                  selected ? index : _selectedType;
                                  showingList =
                                  index == 0 ? builtinBots : customBots;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              selectedColor: Colors.black,
                              labelStyle: TextStyle(
                                  color: _selectedType == index
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
        if (!isLoading && showingList.isEmpty) // if list is empty
          const Center(
              child: Text(
                'Empty list',
                style: TextStyle(color: Colors.grey),
              )),
        if (!isLoading && showingList.isNotEmpty) ...[
          Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: showingList.length,
                itemBuilder: (context, index) {
                  final bot = showingList[index];

                  return ListTile(
                    title: Text(bot.name),
                    leading: CircleAvatar(
                      radius: 13,
                      backgroundImage: AssetImage(bot.image),
                    ),
                    // trailing: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     // edit button
                    //     IconButton(
                    //       icon: const Icon(Icons.edit),
                    //       onPressed: () {
                    //         // TODO: edit bot
                    //       },
                    //     ),
                    //     // delete button
                    //     IconButton(
                    //       icon: const Icon(Icons.delete),
                    //       onPressed: () {
                    //         // TODO: delete list
                    //       },
                    //     ),
                    //     // favorite button
                    //   ],
                    // ),
                    onTap: () {
                      // TODO: select bot
                      // widget.onIconTap(0, text: prompt.content);
                    },
                  );
                },
              ))
        ]
      ],
    );
  }

  // Build Create Bot Section
  // Widget _buildCreateBotSection() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: TextField(
  //             controller: _botNameController,
  //             decoration: const InputDecoration(
  //               labelText: 'Enter Bot Name',
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 10),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Add new bot
  //             if (_botNameController.text.isNotEmpty) {
  //               setState(() {
  //                 customBots.add(_botNameController.text);
  //               });
  //               _botNameController.clear();
  //             }
  //           },
  //           child: const Text('Create Bot'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Build Predefined Bots Section
  Widget _buildPredefinedBotsSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Predefined Bots',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: builtinBots.length,
              itemBuilder: (context, index) {
                final botName = builtinBots[index].name;
                return _buildBotCard(botName, isPredefined: true);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build User-Created Bots Section
  Widget _buildUserCreatedBotsSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'User-Created Bots',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customBots.length,
              itemBuilder: (context, index) {
                final botName = customBots[index];
                return _buildBotCard(botName,
                    isPredefined: false, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build Bot Card (Reused for Both Sections)
  Widget _buildBotCard(String botName,
      {required bool isPredefined, int? index}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(botName),
        subtitle: Text(isPredefined ? 'Predefined Bot' : 'User-Created Bot'),
        trailing: isPredefined
            ? null // No actions for predefined bots
            : PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Update') {
              _showUpdateBotDialog(index!, botName);
            } else if (value == 'Delete') {
              setState(() {
                customBots.removeAt(index!);
              });
            } else if (value == 'Preview') {
              _previewChatWithBot(botName);
            } else if (value == 'Publish') {
              _publishBot(botName);
            }
          },
          itemBuilder: (context) =>
          [
            const PopupMenuItem(value: 'Update', child: Text('Update')),
            const PopupMenuItem(value: 'Delete', child: Text('Delete')),
            const PopupMenuItem(
                value: 'Preview', child: Text('Preview Chat')),
            const PopupMenuItem(value: 'Publish', child: Text('Publish')),
          ],
        ),
        onTap: () {
          if (!isPredefined) {
            _manageBotKnowledge(botName);
          }
        },
      ),
    );
  }

  // Update Bot Dialog
  void _showUpdateBotDialog(int index, String botName) {
    final TextEditingController updateController = TextEditingController();
    updateController.text = botName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Bot'),
          content: TextField(
            controller: updateController,
            decoration: const InputDecoration(labelText: 'Bot Name'),
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
                setState(() {
                  customBots[index] = updateController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Manage Knowledge for a Bot
  void _manageBotKnowledge(String botName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              appBar: AppBar(
                title: Text('Manage Knowledge for $botName'),
              ),
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add or remove knowledge to/from the bot
                  },
                  child: const Text('Add/Remove Knowledge'),
                ),
              ),
            ),
      ),
    );
  }

  // Preview Chat with a Bot
  void _previewChatWithBot(String botName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chat with $botName'),
          content: const Text('This is a preview of the chat functionality.'),
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

  // Publish Bot
  void _publishBot(String botName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Publish $botName'),
          content: const Text('Publish to Slack, Telegram, or Messenger?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement publish logic
              },
              child: const Text('Publish'),
            ),
          ],
        );
      },
    );
  }
}
