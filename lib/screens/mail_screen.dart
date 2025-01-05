import 'package:flutter/material.dart';
import 'package:jarvis_project/services/email_service.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  final EmailService _emailService = EmailService();
  final TextEditingController _controller = TextEditingController();
  List<String> suggestionList = [];
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Hàm gửi email
  Future<void> _sendEmail() async {
    var content = _controller.text;
    if (content.isNotEmpty) {
      try {
        setState(() {
          _isLoading = true;
        });

        // Gửi email qua API
        var response = await _emailService.generateResponseEmail(
          "Follow up on our recent discussion",
          content,
        );

        setState(() {
          _controller.text = ''; // Clear nội dung sau khi gửi
          _showSuccessMessage("Email sent successfully!");
        });
      } catch (e) {
        _showErrorMessage("Failed to send email: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Hiển thị thông báo thành công
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Hiển thị thông báo lỗi
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 242, 242),
        appBar: _buildAppBar(),
        body: _isLoading ? _buildLoadingIndicator() : _buildBody(),
        bottomNavigationBar: _buildBottomChat(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      title: const Text(
        "Email Reply",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontFamily: "Times New Roman",
        ),
        textAlign: TextAlign.left,
        textScaleFactor: 1.3,
      ),
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          children: [
            _buildUserChat(),
            const SizedBox(height: 10.0),
            _buildAIReply(),
            const SizedBox(height: 10.0),
            _buildSuggestionChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserChat() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(235, 210, 227, 252),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Text(
        "Hello Jarvis!\n\nCan you draft a follow-up email for my client?",
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget _buildAIReply() {
    return FutureBuilder<String>(
      future: _emailService.generateResponseEmail(
        "Follow up on our recent discussion",
        "Client email content goes here.",
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Jarvis Reply",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Divider(),
                Text(
                  snapshot.data ?? "",
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSuggestionChips() {
    return FutureBuilder<List<String>>(
      future: _emailService.getSuggestedReplies(
        "Client email content here",
        "Follow up on our recent discussion",
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          suggestionList = snapshot.data ?? [];
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: suggestionList.map((suggestion) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.text = suggestion;
                  });
                },
                child: Chip(
                  label: Text(suggestion),
                  backgroundColor: Colors.grey.shade300,
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildBottomChat() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Compose your email...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _sendEmail,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }
}
