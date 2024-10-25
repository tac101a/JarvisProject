import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 120, 212, 0.1),
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(), // Header (Hi, good afternoon)
                      const SizedBox(height: 12),
                      _buildTopRow(), // GPT-3.5 Turbo row
                      const SizedBox(height: 12),
                      _buildInputField(), // Input Field
                      const SizedBox(height: 12),
                      _buildToolsRow(), // Tool row
                      const SizedBox(height: 12),
                      _buildBottomRow(), // Bottom row
                    ],
                  ),
                ),
              ),
            ),
            // Sidebar will be another part, already implemented in your project
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("👋",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text(
            "Hi, good afternoon!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00213B),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "I’m Jarvis, your personal assistant.",
            style: TextStyle(fontSize: 14, color: Color(0xFF00213B)),
          ),
          const SizedBox(height: 8),
          const Text(
            "Here are some of my amazing powers:",
            style: TextStyle(fontSize: 14, color: Color(0xFF00213B)),
          ),
          const SizedBox(height: 20),
          _buildInfoBox("Add more tools to your Jarvis"),
          const SizedBox(height: 20),
          _buildAISection(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildToolBox(
                  icon: Icons.file_upload,
                  title: "Upload",
                  description: "Click/Drag and drop here to chat",
                  color: const Color(0xFFE0EFFE),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToolBox(
                  icon: Icons.crop,
                  title: "Screenshot & Ask AI",
                  description: "",
                  color: const Color(0xFFE0E7FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: const Row(
              children: [
                Icon(Icons.model_training, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text(
                  'GPT-3.5 Turbo',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF00213B),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.keyboard_arrow_down, size: 14),
              ],
            ),
          ),
          // Use Expanded/Flexible here to prevent overflow
          Flexible(
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // Allow horizontal scrolling for icons
              child: Row(
                children: [
                  _buildIcon(Icons.book),
                  const SizedBox(width: 8),
                  _buildIcon(Icons.image),
                  const SizedBox(width: 8),
                  _buildIcon(Icons.file_present),
                  const SizedBox(width: 8),
                  _buildIcon(Icons.crop),
                  const SizedBox(width: 8),
                  _buildIcon(Icons.settings),
                  const SizedBox(width: 8),
                  _buildIcon(Icons.history),
                  const SizedBox(width: 8),
                  _buildIcon(Icons.add_circle_outline),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          "Ask me anything, press ‘/’ for prompts...",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildToolsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildToolIcon(Icons.add, "Add Tools"),
              const SizedBox(width: 8),
              _buildIcon(Icons.mic),
              const SizedBox(width: 8),
              _buildIcon(Icons.alternate_email),
            ],
          ),
          const Spacer(),
          _buildIcon(Icons.send),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSmallButton('30', Icons.water_drop_outlined),
          Row(
            children: [
              const Text(
                "Upgrade",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFF0078D4),
                ),
              ),
              const SizedBox(width: 4),
              _buildIcon(Icons.rocket_launch_sharp),
            ],
          ),
          Row(
            children: [
              _buildIcon(Icons.card_giftcard),
              const SizedBox(width: 8),
              _buildIcon(Icons.favorite_border),
              const SizedBox(width: 8),
              _buildIcon(Icons.close),
              const SizedBox(width: 8),
              _buildIcon(Icons.mail),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF475569)),
    );
  }

  Widget _buildToolIcon(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        children: [
          Icon(icon, size: 10, color: const Color(0xFF0078D4)),
          const SizedBox(width: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 11,
              color: Color(0xFF0078D4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        children: [
          Icon(icon, size: 10, color: const Color(0xFF0078D4)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for the other sections

  Widget _buildInfoBox(String text) {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00213B)),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF00213B)),
        ],
      ),
    );
  }

  Widget _buildAISection() {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, size: 24, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AI Search",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00213B)),
              ),
              SizedBox(height: 4),
              Text(
                "Smarter and save your time",
                style: TextStyle(fontSize: 14, color: Color(0xFF00213B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolBox(
      {required IconData icon,
      required String title,
      required String description,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0078D4), size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00213B)),
          ),
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description,
                style: const TextStyle(fontSize: 12, color: Color(0xFF00213B)),
              ),
            ),
        ],
      ),
    );
  }
}
