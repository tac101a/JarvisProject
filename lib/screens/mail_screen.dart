import 'package:flutter/material.dart';
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

  final tones = ['Formal', 'Casual', 'Professional'];
  final lengths = ['Short', 'Medium', 'Long'];

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
        style: EmailStyle(tone: selectedTone, length: selectedLength),
        language: 'English',
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
      body: Padding(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  Widget _buildDropdown(String title, List<String> options,
      String selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: selectedValue,
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
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
    return draftEmail.isEmpty
        ? const Text('No draft generated yet.')
        : Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade100,
            ),
            child: Text(draftEmail),
          );
  }
}
