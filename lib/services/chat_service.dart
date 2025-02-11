import 'dart:convert';

import 'package:jarvis_project/models/assistant_model.dart';
import 'package:jarvis_project/services/api_service.dart';

class ChatService {
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

      final response = await apiService.sendMessage(body);

      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  // load all conversation
  Future<String> getAllConversations() async {
    try {
      var param = {
        'assistantId': Assistant.currentBot.id,
        'assistantModel': 'dify'
      };

      final response = await apiService.getAllConversation(param);

      if (response.statusCode == 200) {
        return response.body;
      }
      throw (Exception('Request failed'));
    } catch (e) {
      throw Exception(e);
    }
  }

  // load conversation
  Future<String> loadConversation(String conID) async {
    try {
      var param = {
        'assistantId': Assistant.currentBot.id,
        'assistantModel': 'dify'
      };

      final response = await apiService.loadConversation(conID, param);

      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }
}
