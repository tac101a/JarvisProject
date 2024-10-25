import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter package

class Sidebar extends StatefulWidget {
  final Function(int) onIconTap;

  const Sidebar({super.key, required this.onIconTap});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 62,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 120, 212, 0.1),
              offset: Offset(0, 3),
              blurRadius: 25,
            ),
            BoxShadow(
              color: Color.fromRGBO(12, 145, 235, 0.1),
              offset: Offset(0, 1),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Chevron buttons
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChevronButton(Icons.chevron_left),
                      const SizedBox(width: 8),
                      _buildChevronButton(Icons.chevron_right),
                    ],
                  ),
                ),
                // Main icons
                _buildIcon(0, Icons.chat_bubble, 'Chat'),
                _buildIcon(1, Icons.book, 'Read'),
                _buildIcon(2, Icons.search, 'Search'),
                _buildIcon(3, Icons.create, 'Write'),
                _buildIcon(4, Icons.translate, 'Translate'),
                _buildIcon(5, Icons.palette, 'Art'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  // Additional icons above avatar
                  _buildExtraIcon(Icons.desktop_windows),
                  const SizedBox(height: 8),
                  _buildExtraIcon(Icons.question_mark),
                  const SizedBox(height: 8),
                  _buildExtraIcon(Icons.settings),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      context.go('/login'); // Navigate to AuthScreen for login
                    },
                    child: const CircleAvatar(
                      radius: 13,
                      backgroundImage: AssetImage('lib/assets/avatar.jpg'),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        widget.onIconTap(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 22,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChevronButton(IconData icon) {
    return GestureDetector(
      onTap: () {
        // Handle chevron button press
      },
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(
            icon,
            color: const Color(0xFF334155),
            size: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildExtraIcon(IconData icon) {
    return GestureDetector(
      onTap: () {
        // Handle extra icon press
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            icon,
            color: const Color(0xFF475569),
            size: 18,
          ),
        ),
      ),
    );
  }
}
