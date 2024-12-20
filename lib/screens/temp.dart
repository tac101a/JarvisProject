import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jarvis_project/models/assistant_model.dart';
import 'package:jarvis_project/models/conversation_model.dart';
import 'package:jarvis_project/models/message.dart';
import 'package:jarvis_project/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  // constructor
  final String inputText;

  const ChatScreen({super.key, this.inputText = ''});

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
  bool _isTextInputFocus = false;

  // text field control
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.inputText;

    _focusNode.addListener(() {
      setState(() {
        _isTextInputFocus = _focusNode.hasFocus;
      });
    });

    init();
  }

  // get all conversation
  Future<void> _getConList() async {
    conList.clear();
    var response = await _chatService.getAllConversations();
    final Map<String, dynamic> data = json.decode(response);

    List<dynamic> temp = [];
    for (var item in data['items']) {
      temp.add(Conversation(item['id'], item['title']));
    }

    setState(() {
      conList = temp;
    });
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

        var response = await _chatService.sendMessage(
            content, Assistant.currentBot.id, conID);
        var data = json.decode(response);
        setState(() {
          // replace ... with the reply message
          messages.removeAt(0);
          messages.insert(0, Message('assistant', timestamp, data['message']));
        });

        print(data['remainingUsage']);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(Assistant.currentBot.name!),
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
                        Navigator.of(context).pop();
                        setState(() {
                          _selectedConIndex = -1;
                          messages.clear();
                        });
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator()); // Loading circle
    } else {
      // messages
      return Column(
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
                              ? Colors.lightBlueAccent.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
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
          TextInputBox()
        ],
      );
    }
  }

  Widget TextInputBox() {
    return Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                FilledButton.tonal(
                  onPressed: () {},
                  style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(0),
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.grey.shade200)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Colors.blue,
                        child: Text(
                          'M',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      // Tên
                      Text(
                        'Monica',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),

                // Avatar
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  border: _isTextInputFocus
                      ? Border.all(color: Colors.purple, width: 0.5)
                      : null,
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: 3,
                        style: TextStyle(fontSize: 14.0),
                        focusNode: _focusNode,
                        onSubmitted: (value) {
                          _sendMessage();
                          _focusNode.requestFocus();
                        },
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: 'Ask me anything...',
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        color: Colors.lightBlueAccent[100],
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
