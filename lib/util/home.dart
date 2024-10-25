import 'package:flutter/material.dart';
import 'package:jarvis_project/ui/chat_page.dart';
import 'package:jarvis_project/ui/read.dart';
import 'package:jarvis_project/ui/search.dart';
import 'package:jarvis_project/ui/sidebar.dart';
import 'package:jarvis_project/ui/write.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatPage(),
    const ReadPage(),
    const SearchPage(),
    const WritePage(),
    const PlaceholderPage(title: 'Translate Page'),
    const PlaceholderPage(title: 'Art Page'),
  ];

  void _onIconTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
