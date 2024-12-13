import 'package:flutter/material.dart';
import 'package:jarvis_project/models/assistant_model.dart';

class BotManagementScreen extends StatefulWidget {
  const BotManagementScreen({super.key});

  @override
  State<BotManagementScreen> createState() => _BotManagementScreenState();
}

class _BotManagementScreenState extends State<BotManagementScreen> {
  // Predefined bots (from assistant_model.dart)
  final List<String> predefinedBots = botID.values.toList();

  // User-created bots
  List<String> userCreatedBots = [];

  // Text controller for creating a new bot
  final TextEditingController _botNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Bot Management'),
      ),
      body: Column(
        children: [
          // Section for creating a new bot
          _buildCreateBotSection(),

          // Divider between create bot and lists
          const Divider(),

          // Predefined Bots Section
          _buildPredefinedBotsSection(),

          // User-Created Bots Section
          _buildUserCreatedBotsSection(),
        ],
      ),
    );
  }

  // Build Create Bot Section
  Widget _buildCreateBotSection() {
    return Padding(
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
                  userCreatedBots.add(_botNameController.text);
                });
                _botNameController.clear();
              }
            },
            child: const Text('Create Bot'),
          ),
        ],
      ),
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
              itemCount: predefinedBots.length,
              itemBuilder: (context, index) {
                final botName = predefinedBots[index];
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
              itemCount: userCreatedBots.length,
              itemBuilder: (context, index) {
                final botName = userCreatedBots[index];
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
                      userCreatedBots.removeAt(index!);
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
                  userCreatedBots[index] = updateController.text;
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
