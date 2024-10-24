import 'package:flutter/material.dart';
import 'package:jarvis_project/chat_page.dart';
import 'package:jarvis_project/read.dart';
import 'package:jarvis_project/search.dart';
import 'package:jarvis_project/sidebar.dart';
import 'package:jarvis_project/write.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: ChatPage()),
    const Center(child: ReadPage()),
    const Center(child: SearchPage()),
    const Center(child: WritePage()),
    const Center(child: Text('Translate Page')),
    const Center(child: Text('Art Page')),
  ];

  void _onIconTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarvis'),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 62, // Sidebar should have a fixed width
            child: Sidebar(onIconTap: _onIconTap),
          ),
          Expanded(child: _pages[_currentIndex])
        ],
      ),
    );
  }
}
