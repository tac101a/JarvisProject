const botID = {
  'claude-3-haiku-20240307': 'CLAUDE_3_HAIKU',
  'claude-3-5-sonnet-20240620': 'CLAUDE_3_SONNET',
  'gemini-1.5-flash-latest': 'GEMINI_15_FLASH',
  'gemini-1.5-pro-latest': 'GEMINI_15_PRO',
  'gpt-4o': 'GPT_4O',
  'gpt-4o-mini': 'GPT_4O_MINI'
};

class Assistant {
  static String id = 'gpt-4o-mini';
  static String? name = botID[id];
}
