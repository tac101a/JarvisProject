import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  // States
  bool _isRegenerateClicked = false;
  int _lengthSelectedIndex = 0;
  int _formatSelectedIndex = 0;
  int _toneSelectedIndex = 0;

  // Options
  final List<String> lengthItemList = ["Auto", "Short", "Medium", "Long"];
  final List<String> formatItemList = [
    "Auto",
    "Email",
    "Message",
    "Comment",
    "Paragraph",
    "Article"
  ];
  final List<String> toneItemList = [
    "Auto",
    "Amicable",
    "Casual",
    "Professional"
  ];
  final List<String> languageOptions = ["Auto", "English"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Writing Agent'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Write About",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Tell me what to write for you...",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildLabel("Length"),
            _buildChoiceChips(lengthItemList, _lengthSelectedIndex, (index) {
              setState(() => _lengthSelectedIndex = index);
            }),
            const SizedBox(height: 16),
            _buildLabel("Format"),
            _buildChoiceChips(formatItemList, _formatSelectedIndex, (index) {
              setState(() => _formatSelectedIndex = index);
            }),
            const SizedBox(height: 16),
            _buildLabel("Tone"),
            _buildChoiceChips(toneItemList, _toneSelectedIndex, (index) {
              setState(() => _toneSelectedIndex = index);
            }),
            const SizedBox(height: 16),
            const Text('Output Language'),
            DropdownButton<String>(
              isExpanded: true,
              items: languageOptions
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (value) {},
              hint: const Text('Auto'),
            ),
            const SizedBox(height: 16),
            _buildRegenerateRow(),
            if (_isRegenerateClicked) _buildGeneratedTextSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildChoiceChips(
      List<String> items, int selectedIndex, Function(int) onSelected) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 8.0,
      children: List.generate(items.length, (index) {
        return ChoiceChip(
          label: Text(items[index]),
          selected: selectedIndex == index,
          onSelected: (bool selected) {
            onSelected(selected ? index : -1);
          },
        );
      }),
    );
  }

  Widget _buildRegenerateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('GPT-4'),
        Switch(
          value: true,
          onChanged: (value) {},
        ),
        ElevatedButton(
          onPressed: () {
            setState(() => _isRegenerateClicked = !_isRegenerateClicked);
          },
          child: const Text('Regenerate'),
        ),
      ],
    );
  }

  Widget _buildGeneratedTextSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium...",
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ElevatedButton(
              onPressed: null,
              child: Text("Insert to focus input"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Copy"),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
