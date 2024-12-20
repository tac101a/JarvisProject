const botID = {
  'claude-3-haiku-20240307': 'Claude 3 Haiku',
  'claude-3-5-sonnet-20240620': 'Claude 3 Sonnet',
  'gemini-1.5-flash-latest': 'Gemini 15 Flash',
  'gemini-1.5-pro-latest': 'Gemini 15 Pro',
  'gpt-4o': 'GPT-4o',
  'gpt-4o-mini': 'GPT-4o mini'
};

class Assistant {
  late String id;
  late String name;
  late String type;
  late String instructions;
  late String description;
  late String image;

  static Assistant currentBot =
      Assistant(id: 'gpt-4o-mini', name: botID['gpt-4o-mini']!);

  Assistant(
      {required this.id,
      required this.name,
      this.type = 'builtin',
      this.instructions = '',
      this.description = ''}) {
    var bots = botID.keys.toList();
    if (bots.contains(id)) {
      var index = bots.indexOf(id);
      switch (index) {
        case 0:
        case 1:
          image = 'lib/assets/claude-ai-icon.png';
          break;

        case 2:
        case 3:
          image = 'lib/assets/gemini-icon.png';
          break;

        case 4:
        case 5:
          image = 'lib/assets/openai-icon.png';
          break;

        default:
          image = 'lib/assets/bot-icon.png';
          break;
      }
    } else {
      image = 'lib/assets/bot-icon.png';
    }
  }
}
