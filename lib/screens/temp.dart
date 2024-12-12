import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jarvis_project/models/assistant_model.dart';
import 'package:jarvis_project/models/conversation_model.dart';
import 'package:jarvis_project/models/message.dart';
import 'package:jarvis_project/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // service
  final ChatService _chatService = ChatService();

  // state
  List<dynamic> conList = [];
  List<dynamic> messages = [];
  bool _isLoading = true;
  int _selectedConIndex = -1;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  // get all conversation
  Future<void> _getConList() async {
    conList.clear();
    var response = await _chatService.getAllConversations();
    final Map<String, dynamic> data = json.decode(response);
    List<dynamic> items = data['items'];
    for (var item in items) {
      conList.add(Conversation(item['id'], item['title']));
    }
  }

  void init() async {
    // get all conversations
    await _getConList();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // get messages
  Future<void> _getMessages() async {
    if (_selectedConIndex != -1) {
      try {
        var conversation = conList[_selectedConIndex];
        var response = await _chatService.loadConversation(conversation.id);
        final Map<String, dynamic> data = json.decode(response);

        // get messages
        List<dynamic> items = data['items'];
        for (var item in items) {
          messages.insert(0, Message('user', item['createdAt'], item['query']));
          messages.insert(
              0, Message('assistant', item['createdAt'], item['answer']));
        }
      } catch (e) {
        print(e);
      }
    } else {
      messages.clear();
    }
  }

  // send message
  Future<void> _sendMessage() async {
    // if input text is not empty
    var content = _controller.text;
    if (content.isNotEmpty) {
      // if _selectedConIndex = -1 then create new conversation
      var conID = _selectedConIndex != -1 ? conList[_selectedConIndex].id : '';
      try {
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        setState(() {
          // remove textfield value
          _controller.text = '';

          // add message to message list
          messages.insert(0, Message('user', timestamp, content));

          // show ... when waiting response
          messages.insert(0, Message('assistant', timestamp, '...'));
        });

        var response =
            await _chatService.sendMessage(content, Assistant.id, conID);
        var data = json.decode(response);
        setState(() {
          // replace ... with the reply message
          messages.removeAt(0);
          messages.insert(0, Message('assistant', timestamp, data['message']));
        });

        // if create new conversation
        if (conID.isEmpty) {
          // create new conversation and reload conversation
          setState(() async {
            await _getConList();
            _selectedConIndex = 0;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator()); // Loading circle
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Assistant.name!),
      ),
      drawer: Drawer(
        child: SafeArea(
            child: Column(
          children: [
            // New chat button above
            Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'New Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        // Thực hiện hành động khi bấm nút New Chat
                        print('New Chat button pressed');
                      },
                    ),
                  ],
                )),
            Expanded(
              child: ListView.builder(
                itemCount: conList.length,
                itemBuilder: (context, index) {
                  final item = conList[index];
                  final isSelected = index == _selectedConIndex;
                  return ListTile(
                    // set background color for selected item
                    tileColor: isSelected ? Colors.blue.withOpacity(0.2) : null,
                    title: Text(item.title),
                    onTap: () async {
                      Navigator.of(context).pop(); // close Drawer
                      setState(() {
                        _isLoading = true;
                        _selectedConIndex = index;
                      });
                      messages.clear();
                      await _getMessages();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  );
                },
              ),
            )
          ],
        )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (ctx, index) {
                final message = messages[index];
                final isUserMessage = message.role == 'user';

                return Container(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  margin: const EdgeInsets.all(8.0),
                  child: IntrinsicWidth(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.lightBlueAccent
                              : Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16.0),
                            topRight: const Radius.circular(16.0),
                            bottomLeft: isUserMessage
                                ? const Radius.circular(16.0)
                                : Radius.zero,
                            bottomRight: isUserMessage
                                ? Radius.zero
                                : const Radius.circular(16.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUserMessage)
                              const Text(
                                'AI',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            Text(
                              message.content,
                              style: const TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value) async {
                      _sendMessage;
                    },
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Enter a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
