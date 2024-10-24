import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  // States
  bool _isRegenerateClicked = false; // Nút Regenerate
  int _lengthSelectedIndex = 0; // Lựa chọn length
  int _formatSelectedIndex = 0; // Lựa chọn format
  int _toneSelectedIndex = 0; // Lựa chọn tone

  // Init
  var lengthItemList = ["Auto", "Short", "Medium", "Long"];
  var formatItemList = [
    "Auto",
    "Email",
    "Message",
    "Comment",
    "Paragraph",
    "Article"
  ];
  var toneItemList = ["Auto", "Amicable", "Casual", "Professional"];

  // main
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Writing Agent'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Write About",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Tell me what to write for you...",
                ),
                maxLines: 3,
              ),
              const Text('Length'),
              Wrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  children: List.generate(lengthItemList.length, (index) {
                    return ChoiceChip(
                      label: Text(lengthItemList[index]),
                      selected: _lengthSelectedIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _lengthSelectedIndex = selected ? index : -1;
                        });
                      },
                    );
                  })),
              const SizedBox(height: 16),
              const Text('Format'),
              Wrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  children: List.generate(formatItemList.length, (index) {
                    return ChoiceChip(
                      label: Text(formatItemList[index]),
                      selected: _formatSelectedIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _formatSelectedIndex = selected ? index : -1;
                        });
                      },
                    );
                  })),
              const SizedBox(height: 16),
              const Text('Tone'),
              Wrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  children: List.generate(toneItemList.length, (index) {
                    return ChoiceChip(
                      label: Text(toneItemList[index]),
                      selected: _toneSelectedIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _toneSelectedIndex = selected ? index : -1;
                        });
                      },
                    );
                  })),
              const SizedBox(height: 16),
              const Text('Output Language'),
              DropdownButton<String>(
                items: const [
                  DropdownMenuItem(
                    value: 'Auto',
                    child: Text('Auto'),
                  ),
                  DropdownMenuItem(
                    value: 'English',
                    child: Text('English'),
                  ),
                  // Add more languages as needed
                ],
                onChanged: (value) {},
                hint: const Text('Auto'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('GPT-4'),
                  Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isRegenerateClicked = !_isRegenerateClicked;
                      });
                      ;
                    },
                    child: const Text('Regenerate'),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              if (_isRegenerateClicked)
                Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: SingleChildScrollView(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                  "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const ElevatedButton(
                            onPressed: null,
                            child: Text("Insert to focus input")),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("Copy"))
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                )
            ],
          ),
        )));
  }
}
