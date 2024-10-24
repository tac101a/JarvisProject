import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: screenWidth *
                0.9, // Adjusts width dynamically based on screen size
            height: screenHeight, // Takes the full height of the screen
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 120, 212, 0.1),
                  blurRadius: 25,
                  offset: Offset(0, 3),
                ),
                BoxShadow(
                  color: Color.fromRGBO(12, 145, 235, 0.1),
                  blurRadius: 6,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("👋",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
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
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF00213B)),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Here are some of my amazing powers:",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF00213B)),
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
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildModelSelector(),
                        const SizedBox(height: 12),
                        _buildIconRow(),
                        const SizedBox(height: 12),
                        _buildInputField(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for building widgets

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

  Widget _buildModelSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.model_training, color: Colors.green, size: 18),
              SizedBox(width: 8),
              Text(
                "GPT-3.5 Turbo",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF00213B)),
              ),
              SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconBox(Icons.book),
        _buildIconBox(Icons.image),
        _buildIconBox(Icons.file_present),
        _buildIconBox(Icons.crop),
      ],
    );
  }

  Widget _buildIconBox(IconData icon) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, size: 18, color: const Color(0xFF475569)),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        "Ask me anything, press ‘/’ for prompts...",
        style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
      ),
    );
  }
}
