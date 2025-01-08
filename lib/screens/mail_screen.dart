import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_project/models/email_reply.dart';
import 'package:jarvis_project/services/email_service.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  final MailService _mailService = MailService();
  final TextEditingController _originalEmailController =
      TextEditingController();
  final TextEditingController _replyIdeaController = TextEditingController();

  String draftEmail = '';
  String selectedTone = 'Formal';
  String selectedLength = 'Medium';
  String selectedFormality = 'Neutral';
  String selectedLanguage = 'English';

  final tones = ['Formal', 'Casual', 'Professional'];
  final lengths = ['Short', 'Medium', 'Long'];
  final formalities = ['Formal', 'Neutral', 'Informal'];
  final languages = ['English', 'Vietnamese', 'French'];
  final aiActions = [
    'Thanks',
    'Sorry',
    'Yes',
    'No',
    'Follow Up',
    'Request for more infor'
  ];

  bool isLoading = false;

  void _generateDraft() async {
    setState(() {
      isLoading = true;
    });

    final emailReply = EmailReply(
      mainIdea: _replyIdeaController.text,
      action: 'Reply to this email',
      email: _originalEmailController.text,
      metadata: EmailMetadata(
        context: [], // Truyền một danh sách rỗng nếu không có dữ liệu ban đầu
        style: EmailStyle(
          tone: selectedTone.toLowerCase(),
          formality: selectedFormality.toLowerCase(),
          length: selectedLength.toLowerCase(),
        ),
        language: selectedLanguage.toLowerCase(),
        subject: 'Default Subject',
        sender: 'default-sender@example.com',
        receiver: 'default-receiver@example.com',
      ),
    );

    try {
      final response = await _mailService.generateResponseEmail(emailReply);
      setState(() {
        draftEmail = response.email;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Email Reply'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmailInputSection(),
              const SizedBox(height: 16),
              _buildOptions(),
              const SizedBox(height: 16),
              _buildGenerateButton(),
              const SizedBox(height: 16),
              _buildDraftDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Original Email:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _originalEmailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter original email content...',
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        const Text('Reply Idea:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _replyIdeaController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter main idea for reply...',
          ),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDropdown('Tone', tones, selectedTone, (value) {
              setState(() {
                selectedTone = value!;
              });
            }),
            _buildDropdown('Length', lengths, selectedLength, (value) {
              setState(() {
                selectedLength = value!;
              });
            }),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDropdown('Formality', formalities, selectedFormality,
                (value) {
              setState(() {
                selectedFormality = value!;
              });
            }),
            _buildDropdown('Language', languages, selectedLanguage, (value) {
              setState(() {
                selectedLanguage = value!;
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String title, List<String> options,
      String selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 150, // Đặt chiều rộng cố định cho dropdown
          child: DropdownButton<String>(
            isExpanded: true, // Đảm bảo dropdown mở rộng toàn bộ chiều rộng
            value: selectedValue,
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: isLoading ? null : _generateDraft,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Generate Draft'),
      ),
    );
  }

  Widget _buildDraftDisplay() {
    if (draftEmail.isEmpty) {
      return const Text('No draft generated yet.');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Text(
                  'AI reply',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),

                // Nội dung email
                Text(
                  draftEmail,
                  style: const TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 16.0),

                // Hành động (nút sao chép)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.grey),
                      onPressed: () {
                        // Xử lý logic sao chép
                        Clipboard.setData(ClipboardData(text: draftEmail));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Draft copied to clipboard!')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // Thêm AI Actions
          Wrap(
            alignment: WrapAlignment.center, // Căn giữa các nút
            spacing: 8.0,
            runSpacing: 8.0, // Khoảng cách giữa các dòng
            children: aiActions.map((action) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade50, // Màu nền
                  foregroundColor: Colors.purple, // Màu chữ
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Bo góc các nút
                  ),
                ),
                onPressed: isLoading ? null : () => _onAIActionSelected(action),
                child: Text(action),
              );
            }).toList(),
          )
        ],
      );
    }
  }

  void _onAIActionSelected(String action) async {
    setState(() {
      isLoading = true;
    });

    try {
      final emailReply = EmailReply(
        mainIdea: action,
        action: 'Reply to this email',
        email: _originalEmailController.text,
        metadata: EmailMetadata(
          style: EmailStyle(
            tone: selectedTone,
            formality: selectedFormality,
            length: selectedLength,
          ),
          language: selectedLanguage,
          context: [], // Thêm context nếu cần
          subject: 'Default Subject',
          sender: 'default-sender@example.com',
          receiver: 'default-receiver@example.com',
        ),
      );

      final response = await _mailService.generateResponseEmail(emailReply);
      setState(() {
        draftEmail = response.email;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
