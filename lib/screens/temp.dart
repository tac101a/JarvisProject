import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jarvis_project/components/error_modal.dart';
import 'package:jarvis_project/models/assistant_model.dart';
import 'package:jarvis_project/models/conversation_model.dart';
import 'package:jarvis_project/models/message_model.dart';
import 'package:jarvis_project/models/thread_model.dart';
import 'package:jarvis_project/models/user_model.dart';
import 'package:jarvis_project/services/assistant_service.dart';
import 'package:jarvis_project/services/chat_service.dart';
import 'package:jarvis_project/services/prompt_service.dart';

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
  final AssistantService _assistantService = AssistantService();

  // state
  List<dynamic> conList = [];
  List<dynamic> messages = [];
  bool _isLoading = true;
  int _selectedConIndex = -1;
  bool _isTextInputFocus = false;
  bool isBuiltinBot = Assistant.currentBot.type == 'builtin';

  // text field control
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  // prompt control for quick slash
  OverlayEntry? _overlayEntry;
  List<dynamic> _filteredPrompts = [];
  bool _isPromptOverlayVisible = false;
  final PromptService _promptService = PromptService();

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchPrompts(); // Tải danh sách prompt
    _controller.text = widget.inputText;

    _focusNode.addListener(() {
      setState(() {
        _isTextInputFocus = _focusNode.hasFocus;
      });
    });

    init();
  }

  // Hàm tải prompt từ backend
  Future<void> _fetchPrompts() async {
    try {
      var response = await _promptService.getPrompt(); // API call
      final data = json.decode(response);

      // Debug: Check the data being loaded
      // print('Prompts Response: $data');

      setState(() {
        // Handle cases where 'items' might be null
        _filteredPrompts = data['items'] ?? [];
      });
    } catch (e) {
      print('Error loading prompts: $e');
      _filteredPrompts = []; // Fallback to empty list
    }
  }

  // get all conversation
  Future<void> _getConList() async {
    try {
      conList.clear();
      List<dynamic> temp = [];

      if (isBuiltinBot) {
        var response = await _chatService.getAllConversations();
        final Map<String, dynamic> data = json.decode(response);

        for (var item in data['items']) {
          temp.add(Conversation(item['id'], item['title']));
        }
      } else {
        var response = await _assistantService.getAllThreads();
        final Map<String, dynamic> data = json.decode(response);

        for (var item in data['data']) {
          temp.add(Thread(
              item['openAiThreadId'], item['assistantId'], item['threadName']));
        }
      }
      setState(() {
        conList = temp;
      });
    } catch (e) {
      showErrorModal(context, e.toString());
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
        if (isBuiltinBot) {
          // builtin bot
          var conversation = conList[_selectedConIndex];
          var response = await _chatService.loadConversation(conversation.id);
          final Map<String, dynamic> data = json.decode(response);

          // get messages
          List<dynamic> items = data['items'];
          for (var item in items) {
            messages.insert(
                0, Message('user', item['createdAt'], item['query']));
            messages.insert(
                0, Message('assistant', item['createdAt'], item['answer']));
          }
        } else {
          // custom bot
          var conversation = conList[_selectedConIndex];
          var response = await _assistantService
              .getThreadMessages(conversation.openAiThreadId);
          final List<dynamic> data = json.decode(response);

          // get messages
          List<dynamic> items = data;
          for (var item in items) {
            messages.add(Message(item['role'], item['createdAt'],
                item['content'][0]['text']['value']));
          }
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
      try {
        int timestamp = DateTime
            .now()
            .millisecondsSinceEpoch;
        setState(() {
          // remove textfield value
          _controller.text = '';

          // switch to chat phase
          _selectedConIndex = 0;

          // add message to message list
          messages.insert(0, Message('user', timestamp, content));

          // show ... when waiting response
          messages.insert(0, Message('assistant', timestamp, '...'));
        });

        if (isBuiltinBot) {
          if (User.remainingUsage > 0) {
            // if _selectedConIndex = -1 then create new conversation
            var conID =
            _selectedConIndex != -1 ? conList[_selectedConIndex].id : '';

            var response = await _chatService.sendMessage(
                content, Assistant.currentBot.id, conID);
            var data = json.decode(response);
            setState(() {
              // replace ... with the reply message
              messages.removeAt(0);
              messages.insert(
                  0, Message('assistant', timestamp, data['message']));
            });

            User.remainingUsage--;
            // if create new conversation
            if (conID.isEmpty) {
              // create new conversation and reload conversation
              setState(() async {
                await _getConList();
                _selectedConIndex = 0;
              });
            }
          } else {
            // out of usage
            throw Exception('Out of usage. Please comeback tomorrow.');
          }
        } else {
          // create new thread
          Thread thread;
          if (_selectedConIndex == -1) {
            var response = await _assistantService.createThread(
              id: Assistant.currentBot.id,
              message: content,
            );

            setState(() {
              _getConList();
              _selectedConIndex = 0;
            });

            var data = json.decode(response);
            thread = Thread(data['openAiThreadId'], data['assistantId'],
                data['threadName']);
          } else {
            thread = conList[_selectedConIndex];
          }

          var response = await _assistantService.askAssistant(
              assistantId: thread.assistantId,
              threadId: thread.openAiThreadId,
              message: content);

          print(response);
          setState(() {
            // replace ... with the reply message
            messages.removeAt(0);
            messages.insert(0, Message('assistant', timestamp, response));
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void _showPromptOverlay(String query) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove(); // Remove old overlay
      _overlayEntry = null;
    }

    // Filter prompts based on the query
    String searchText = query.startsWith('/')
        ? query.substring(1).toLowerCase()
        : query.toLowerCase();
    List<dynamic> filtered = _filteredPrompts.where((prompt) {
      return prompt['title'].toLowerCase().contains(searchText);
    }).toList();

    if (filtered.isEmpty) {
      _removePromptOverlay(); // Hide overlay if the list is empty
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset textFieldOffset = renderBox.localToGlobal(Offset.zero);
      final bottomInset = MediaQuery
          .of(context)
          .viewInsets
          .bottom;

      final overlay = Overlay.of(context);

      // Create OverlayEntry
      _overlayEntry = OverlayEntry(
        builder: (context) =>
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height -
                  textFieldOffset.dy -
                  renderBox.size.height -
                  bottomInset +
                  60,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200, // Limit the height of the overlay
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Scrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final prompt = filtered[index];

                          // Ensure prompt fields are not null
                          final title = prompt['title'] ?? 'Untitled';
                          final description =
                              prompt['description'] ??
                                  'No description available';
                          final content = prompt['content'] ?? '';
                          return ListTile(
                            title: Text(title),
                            subtitle: Text(description),
                            onTap: () {
                              // Replace the current text with the prompt content
                              _controller.text = _controller.text.replaceAll(
                                RegExp(r'/\w*$'),
                                content,
                              );
                              _controller.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _controller.text.length),
                                  );
                              _removePromptOverlay(); // Close the overlay
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
      );

      overlay.insert(_overlayEntry!);
      _isPromptOverlayVisible = true;
    });
  }

  void _removePromptOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _isPromptOverlayVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Assistant.currentBot.name),
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
                        tileColor: isSelected
                            ? Colors.blue.withOpacity(0.2)
                            : null,
                        title: Text(
                            isBuiltinBot ? item.title : item.threadName),
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
          if (_selectedConIndex == -1)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(Assistant.currentBot.image),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Hello, May I help you?',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          if (_selectedConIndex != -1)
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
                            maxWidth: MediaQuery
                                .of(context)
                                .size
                                .width * 0.7),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              Text(
                                message.content,
                                style: const TextStyle(fontSize: 14),
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
          textInputBox()
        ],
      );
    }
  }

  Widget textInputBox() {
    return Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                decoration: BoxDecoration(
                  border: _isTextInputFocus
                      ? Border.all(color: Colors.purple, width: 0.5)
                      : Border.all(color: Colors.grey.shade200, width: 0.5),
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 6,
                        style: const TextStyle(fontSize: 14.0),
                        focusNode: _focusNode,
                        onChanged: (value) {
                          if (value.endsWith('/')) {
                            _showPromptOverlay(
                                value); // Hiển thị danh sách prompt
                          } else if (_isPromptOverlayVisible) {
                            _removePromptOverlay(); // Đóng overlay nếu không còn cần thiết
                          }
                        },
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          _sendMessage();
                          _focusNode.requestFocus();
                        },
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: 'Ask me anything...',
                            border: InputBorder.none,
                            isDense: true),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      onPressed: () {
                        _sendMessage();
                        _focusNode.requestFocus();
                      },
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
