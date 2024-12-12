import 'dart:convert';

import 'package:jarvis_project/models/assistant_model.dart';
import 'package:jarvis_project/services/api_service.dart';

class ChatService {
  final ApiService _apiService = ApiService();

  // send message
  Future<String> sendMessage(String content, String botID, String conID) async {
    try {
      var body = json.encode({
        "content": content,
        "metadata": {
          "conversation": {"messages": [], "id": conID},
        },
        "assistant": {"id": botID, "model": "dify"}
      });

      final response = await _apiService.sendMessage(body);

      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  // load all conversation
  Future<String> getAllConversations() async {
    try {
      var param = {'assistantId': Assistant.id, 'assistantModel': 'dify'};

      final response = await _apiService.getAllConversation(param);

      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  // load conversation
  Future<String> loadConversation(String conID) async {
    try {
      var param = {'assistantId': Assistant.id, 'assistantModel': 'dify'};

      final response = await _apiService.loadConversation(conID, param);

      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }
}
