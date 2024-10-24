import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'sidebar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            // Constrain the width of ChatPage using Expanded or Flexible
            Expanded(
              flex: 3, // Adjust flex as needed to control width
              child: ChatPage(),
            ),

            // Constrain the width of Sidebar using a fixed width or flex
            SizedBox(
              width: 62, // Sidebar should have a fixed width
              child: Sidebar(),
            ),
          ],
        ),
      ),
    );
  }
}
