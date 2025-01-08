import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jarvis_project/models/assistant_model.dart';
import 'package:jarvis_project/models/knowledge_model.dart';
import 'package:jarvis_project/services/assistant_service.dart';
import 'package:jarvis_project/services/knowledge_service.dart';

import '../components/error_modal.dart';
import '../components/search_bar.dart';
import '../style/styles.dart';

class BotManagementScreen extends StatefulWidget {
  final Function(int, {String text}) onBotSelect;

  const BotManagementScreen({super.key, required this.onBotSelect});

  @override
  State<BotManagementScreen> createState() => _BotManagementScreenState();
}

class _BotManagementScreenState extends State<BotManagementScreen> {
  // service
  final AssistantService _assistantService = AssistantService();
  final KnowledgeService _knowledgeService = KnowledgeService();

  // text field controller
  TextEditingController dialogNameController = TextEditingController();
  TextEditingController dialogInstructionController = TextEditingController();
  TextEditingController dialogDescriptionController = TextEditingController();

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
  bool isDialogLoading = false;
  List<dynamic> showingList = [];
  List<dynamic> botKBList = [];
  List<dynamic> kbList = [];

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
    dialogNameController.dispose();
    dialogInstructionController.dispose();
    dialogDescriptionController.dispose();
  }

  Future<void> _getBots() async {
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
            type: 'custom',
            instruction: item['instructions'] ?? '',
            description: item['description'] ?? ''));
      }

      setState(() {
        customBots = temp;
        isLoading = false;

        if (_selectedType == 1) showingList = customBots;
      });
    } catch (e) {
      showErrorModal(context, e.toString());
      print(e);
    }
  }

  Future<void> _createBot() async {
    var res = await _assistantService.createAssistant(
        name: dialogNameController.text,
        instructions: dialogInstructionController.text,
        description: dialogDescriptionController.text);

    if (res) {
      print('deleted');
      _getBots();
    }
  }

  Future<void> _updateBot(String id) async {
    var res = await _assistantService.updateAssistant(
      id,
      name: dialogNameController.text,
      instructions: dialogInstructionController.text,
      description: dialogDescriptionController.text,
    );

    if (res) {
      _getBots();
    }
  }

  Future<void> _deleteBot(String id) async {
    try {
      setState(() {
        isLoading = true;
      });
      var res = await _assistantService.deleteAssistant(id);

      if (res) {
        _getBots();
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

  void resetDialogState() {
    setState(() {
      botKBList.clear();
      kbList.clear();
    });
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // edit button
                    if (_selectedType == 1)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Edit prompt
                          setState(() {
                            dialogNameController.text = bot.name;
                            dialogInstructionController.text = bot.instruction;
                            dialogDescriptionController.text = bot.description;
                          });

                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return _buildDialog(context, setState, 'update',
                                    assistant: bot);
                              });
                            },
                          ).then((result) {
                            resetDialogState();
                          });
                        },
                      ),
                    // delete button
                    if (_selectedType == 1)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: dialogTitle('Delete Bot',
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
                                        _deleteBot(bot.id);
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
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      bool isAPICalled = false;

                      return StatefulBuilder(builder: (context, setState) {
                        if (bot.type == 'custom') {
                          Future<void> getAssistantKnowledge(String id) async {
                            try {
                              var response = await _assistantService
                                  .getAssistantKnowledge(id);
                              var data = json.decode(response);

                              List<dynamic> temp = [];
                              for (var item in data['data']) {
                                temp.add(Knowledge(
                                    id: item['id'],
                                    name: item['knowledgeName'],
                                    description: item['description']));

                                setState(() {
                                  botKBList = temp;
                                });
                              }
                            } catch (e) {
                              showErrorModal(context, e.toString());
                            }
                          }

                          Future<void> getKnowledgeList() async {
                            try {
                              var response =
                                  await _knowledgeService.getKnowledge();
                              var data = json.decode(response);

                              List<dynamic> temp = [];
                              for (var item in data['data']) {
                                temp.add(Knowledge(
                                    id: item['id'],
                                    name: item['knowledgeName'],
                                    description: item['description']));
                              }

                              setState(() {
                                kbList = temp.where((element) {
                                  for (var item in botKBList) {
                                    if (item.id == element.id) {
                                      return false;
                                    }
                                  }
                                  return true;
                                }).toList();
                              });
                            } catch (e) {
                              showErrorModal(context, e.toString());
                            }
                          }

                          Future<void> apiCall(String id) async {
                            try {
                              setState(() {
                                isDialogLoading = true;
                              });

                              await getAssistantKnowledge(id);
                              await getKnowledgeList();

                              if (mounted) {
                                setState(() {
                                  isDialogLoading = false;
                                });
                              }
                            } catch (e) {
                              showErrorModal(context, e.toString());
                            }
                          }

                          if (!isAPICalled) {
                            isAPICalled = true;
                            apiCall(bot.id);
                          }
                        }

                        return _buildDialog(context, setState, 'view',
                            assistant: bot);
                      });
                    },
                  ).then((result) {
                    resetDialogState();
                  });
                },
              );
            },
          ))
        ]
      ],
    );
  }

  Widget _buildDialog(BuildContext context, Function setState, String action,
      {Assistant? assistant}) {
    bool isViewing = action == 'view';

    String title = '';
    String submitText = '';
    Function onSubmit = () {};

    switch (action) {
      case 'create':
        title = 'New Assistant';
        dialogDescriptionController.text = '';
        dialogInstructionController.text = '';
        submitText = 'Create';
        onSubmit = _createBot;
        break;

      case 'update':
        title = 'Update Assistant';
        dialogDescriptionController.text = assistant!.description;
        dialogInstructionController.text = assistant.instruction;
        submitText = 'Update';
        onSubmit = () {
          _updateBot(assistant.id);
        };
        break;

      case 'view':
        title = assistant!.name;
        dialogDescriptionController.text = assistant.description;
        dialogInstructionController.text = assistant.instruction;
        submitText = 'Use Assistant';
        onSubmit = () {
          Assistant.currentBot = assistant;
          widget.onBotSelect(0);
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
                  const Text(
                    'Name',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    style: const TextStyle(fontSize: 12),
                    controller: dialogNameController,
                    decoration: dialogInputField('Name of your assistant'),
                  ),
                  const SizedBox(height: 16.0)
                ],
                const Text(
                  'Instruction',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  maxLines: isViewing ? null : 2,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  controller: dialogInstructionController,
                  readOnly: isViewing,
                  enabled: !isViewing,
                  decoration: dialogInputField(
                      isViewing && assistant!.instruction.isEmpty
                          ? 'No instruction'
                          : 'e.g: You are an assistant of the Jarvis system'),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  maxLines: isViewing ? null : 3,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  controller: dialogDescriptionController,
                  readOnly: isViewing,
                  enabled: !isViewing,
                  decoration: dialogInputField(isViewing &&
                          assistant!.instruction.isEmpty
                      ? 'No description'
                      : 'e.g: This bot is used to ask about the Jarvis system....'),
                ),
                if (action != 'create' && assistant?.type == 'custom') ...[
                  const SizedBox(height: 16.0),
                  const Text(
                    'Knowledge',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  if (isDialogLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (!isDialogLoading) ...[
                    if (botKBList.isEmpty)
                      const Center(
                          child: Text(
                        'Empty list',
                        style: TextStyle(color: Colors.grey),
                      )),
                    if (botKBList.isNotEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: botKBList.length,
                          itemBuilder: (context, index) {
                            final unit = botKBList[index];

                            return ListTile(
                              title: Text(
                                '${index + 1}. ${unit.name}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                  onPressed: () async {
                                    var response = await _assistantService
                                        .deleteKnowledgeFromAssistant(
                                            botID: assistant!.id,
                                            kbID: unit.id);

                                    if (mounted) {
                                      if (response) {
                                        setState(() {
                                          kbList.add(unit);
                                          botKBList.remove(unit);
                                        });

                                        // show snackbar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Deleted')));
                                      } else {
                                        throw Exception('Request failed');
                                      }
                                    }
                                  },
                                  icon: Icon(Icons.delete)),
                            );
                          }),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 20,
                      indent: 10,
                      endIndent: 10,
                    ),
                    const Text(
                      'Add knowledge',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    if (kbList.isEmpty)
                      const Center(
                          child: Text(
                        'Empty list',
                        style: TextStyle(color: Colors.grey),
                      )),
                    if (kbList.isNotEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: kbList.length,
                          itemBuilder: (context, index) {
                            final kb = kbList[index];

                            return ListTile(
                              title: Text(
                                '${index + 1}. ${kb.name}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                  onPressed: () async {
                                    try {
                                      await _assistantService
                                          .addKnowledgeToAssistant(
                                              botID: assistant!.id,
                                              kbID: kb.id);

                                      if (mounted) {
                                        setState(() {
                                          kbList.remove(kb);
                                          botKBList.add(kb);
                                        });

                                        // show snackbar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Added successfully')));
                                      }
                                    } catch (e) {
                                      showErrorModal(context, e.toString());
                                    }
                                  },
                                  icon: Icon(Icons.add)),
                            );
                          })
                  ],
                ]
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
                itemBuilder: (context) => [
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
        builder: (context) => Scaffold(
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
