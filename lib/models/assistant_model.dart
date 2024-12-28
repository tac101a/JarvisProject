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
  late String type; // [builtin, custom]
  late String instruction;
  late String description;
  late String image;

  static Assistant currentBot =
      Assistant(id: 'gpt-4o-mini', name: botID['gpt-4o-mini']!);

  Assistant(
      {required this.id,
      required this.name,
      this.type = 'builtin',
      this.instruction = '',
      this.description = ''}) {
    var bots = botID.keys.toList();
    if (bots.contains(id)) {
      var index = bots.indexOf(id);
      switch (index) {
        case 0:
          instruction =
              'You are an assistant specialized in crafting short and creative responses, like haikus or brief ideas.';
          description =
              'This bot generates concise and creative outputs, ideal for poetry or short-form content.';
          image = 'lib/assets/claude-ai-icon.png';
          break;

        case 1:
          instruction =
              'You are an assistant designed to produce creative and elaborate content, such as sonnets or detailed explanations.';
          description =
              'This bot helps users with creative writing tasks, focusing on structured and expressive outputs.';
          image = 'lib/assets/claude-ai-icon.png';
          break;

        case 2:
          instruction =
              'You are a high-speed assistant optimized for delivering quick and precise responses to user queries.';
          description =
              'This bot is designed for tasks requiring rapid answers, ensuring efficiency without compromising accuracy.';
          image = 'lib/assets/gemini-icon.png';
          break;

        case 3:
          instruction =
              'You are an advanced assistant capable of providing detailed and in-depth solutions for complex tasks.';
          description =
              'This bot excels in handling sophisticated queries with comprehensive and well-researched responses.';
          image = 'lib/assets/gemini-icon.png';
          break;

        case 4:
          instruction =
              'You are an assistant built to provide detailed, context-aware, and high-quality answers for a variety of tasks.';
          description =
              'This bot is versatile, offering in-depth assistance for complex and general-purpose queries.';
          image = 'lib/assets/openai-icon.png';
          break;

        case 5:
          instruction =
              'You are a lightweight assistant optimized for fast processing while maintaining accurate and concise responses.';
          description =
              'This bot balances speed and precision, ideal for simpler tasks or when quick answers are needed.';
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
