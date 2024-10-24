import 'package:flutter/material.dart';

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
                // Top Buttons with Chevrons
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChevronButton(Icons.chevron_left, () {
                        // Handle Chevron Left Press
                      }),
                      const SizedBox(width: 8),
                      _buildChevronButton(Icons.chevron_right, () {
                        // Handle Chevron Right Press
                      }),
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
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  // Three additional icons above avatar
                  _buildExtraIcon(Icons.desktop_windows, () {
                    // Handle Desktop Icon Press
                  }),
                  const SizedBox(height: 8),
                  _buildExtraIcon(Icons.question_mark, () {
                    // Handle Help Icon Press
                  }),
                  const SizedBox(height: 8),
                  _buildExtraIcon(Icons.settings, () {
                    // Handle Settings Icon Press
                  }),
                  const SizedBox(height: 16),
                  const CircleAvatar(
                    radius: 13,
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                  ),
                  const SizedBox(height: 10), // Space between avatar and bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onIconTap(index); // notify to parent on icon tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(icon,
                color: _selectedIndex == index ? Colors.blue : Colors.grey,
                size: 22),
            if (label.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _selectedIndex == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChevronButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
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

  Widget _buildExtraIcon(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
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
