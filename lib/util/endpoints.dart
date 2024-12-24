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
  'createAssistant': '/kb-core/v1/ai-assistant'
};
