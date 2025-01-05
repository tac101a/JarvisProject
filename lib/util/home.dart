import 'package:flutter/material.dart';
import 'package:jarvis_project/screens/sidebar.dart';
import 'package:jarvis_project/screens/temp.dart';
import 'package:jarvis_project/screens/prompt_screen.dart';
import 'package:jarvis_project/screens/bot_management.dart';
import 'package:jarvis_project/screens/knowledge_base.dart';
import 'package:jarvis_project/screens/mail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // state
  int _currentIndex = 0;
  String _inputText = '';

  // screen list
  late final List<Widget> _pages;

  // change screen when click to sidebar
  void _onIconTap(int index, {String text = ''}) {
    setState(() {
      _currentIndex = index;

      _inputText = text;
      _pages[0] = ChatScreen(
        inputText: text,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _pages = [
      ChatScreen(
        inputText: _inputText,
      ),
      BotManagementScreen(
        onBotSelect: _onIconTap,
      ),
      PromptScreen(
        onPromptSelect: _onIconTap,
      ),
      const KnowledgeBaseScreen(),
      const MailScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Main content on the left
          Expanded(child: _pages[_currentIndex]),
          // Sidebar on the right
          Sidebar(
            onIconTap: _onIconTap,
            currentIndex: _currentIndex,
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, color: Colors.grey),
      ),
    );
  }
}
