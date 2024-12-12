import 'package:flutter/material.dart';
import 'package:jarvis_project/screens/chat_screens.dart';
import 'package:jarvis_project/screens/read.dart';
import 'package:jarvis_project/screens/search.dart';
import 'package:jarvis_project/screens/sidebar.dart';
import 'package:jarvis_project/screens/temp.dart';
import 'package:jarvis_project/screens/write.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // state
  int _currentIndex = 0;

  // screen list
  final List<Widget> _pages = [
    const ChatScreen(),
    const ReadPage(),
    const SearchPage(),
    const WritePage(),
    const PlaceholderPage(title: 'Translate Page'),
    const PlaceholderPage(title: 'Art Page'),
  ];

  // change screen when click to sidebar
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
