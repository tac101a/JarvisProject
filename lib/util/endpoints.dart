const authEndpoints = {
  'signIn': '/api/v1/auth/sign-in',
  'signUp': '/api/v1/auth/sign-up',
  'signOut': '/api/v1/auth/sign-out',
  'getUser': '/api/v1/auth/me',
  'refreshToken': '/api/v1/auth/refresh'
};

const chatEndpoints = {
  'sendMessage': '/api/v1/ai-chat/messages',
  'getAllConversations': '/api/v1/ai-chat/conversations',
  'getConversationHistory': '/api/v1/ai-chat/conversations/'
};

const promptEndpoints = {
  'getPrompt': '/api/v1/prompts',
  'createPrompt': '/api/v1/prompts',
  'addPromptToFavorite': '/api/v1/prompts/',
  'removePromptFromFavorite': '/api/v1/prompts/',
  'updatePrompt': '/api/v1/prompts/',
  'deletePrompt': '/api/v1/prompts/'
};

const aiEndpoints = {
  'kbSignIn': '/kb-core/v1/auth/external-sign-in',
  'getAssistant': '/kb-core/v1/ai-assistant',
  'createAssistant': '/kb-core/v1/ai-assistant',
  'deleteAssistant': '/kb-core/v1/ai-assistant/',
  'updateAssistant': '/kb-core/v1/ai-assistant/',
  'getThread': '/kb-core/v1/ai-assistant/',
  'createThread': '/kb-core/v1/ai-assistant/thread',
  'getMessages': '/kb-core/v1/ai-assistant/thread/',
  'chat': '/kb-core/v1/ai-assistant/',
};

const kbEndpoints = {
  'getKnowledge': '/kb-core/v1/knowledge',
  'createKnowledge': '/kb-core/v1/knowledge',
  'deleteKnowledge': '/kb-core/v1/knowledge/',
  'updateKnowledge': '/kb-core/v1/knowledge/',
  'getKnowledgeUnit': '/kb-core/v1/knowledge/',
  'addWebsite': '/kb-core/v1/knowledge/',
  'addFile': '/kb-core/v1/knowledge/',
  'addSlack': '/kb-core/v1/knowledge/',
  'addConfluence': '/kb-core/v1/knowledge/'
};
