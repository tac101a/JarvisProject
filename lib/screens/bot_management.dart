import 'package:flutter/material.dart';

class BotManagementScreen extends StatefulWidget {
  const BotManagementScreen({super.key});

  @override
  State<BotManagementScreen> createState() => _BotManagementScreenState();
}

class _BotManagementScreenState extends State<BotManagementScreen> {
  // State for managing bots
  List<String> bots = ['Bot 1', 'Bot 2', 'Bot 3']; // Example bot names
  final TextEditingController _botNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Bot Management'),
      ),
      body: Column(
        children: [
          // Create Bot Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _botNameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Bot Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add new bot
                    if (_botNameController.text.isNotEmpty) {
                      setState(() {
                        bots.add(_botNameController.text);
                      });
                      _botNameController.clear();
                    }
                  },
                  child: const Text('Create Bot'),
                ),
              ],
            ),
          ),
          const Divider(),

          // List of Bots
          Expanded(
            child: ListView.builder(
              itemCount: bots.length,
              itemBuilder: (context, index) {
                final botName = bots[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(botName),
                    subtitle: const Text('AI Bot Details'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Update') {
                          _showUpdateBotDialog(index, botName);
                        } else if (value == 'Delete') {
                          setState(() {
                            bots.removeAt(index);
                          });
                        } else if (value == 'Preview') {
                          _previewChatWithBot(botName);
                        } else if (value == 'Publish') {
                          _publishBot(botName);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: 'Update', child: Text('Update')),
                        const PopupMenuItem(
                            value: 'Delete', child: Text('Delete')),
                        const PopupMenuItem(
                            value: 'Preview', child: Text('Preview Chat')),
                        const PopupMenuItem(
                            value: 'Publish', child: Text('Publish')),
                      ],
                    ),
                    onTap: () {
                      _manageBotKnowledge(botName);
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
                  bots[index] = updateController.text;
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
