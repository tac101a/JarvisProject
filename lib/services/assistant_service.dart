import 'package:jarvis_project/services/api_service.dart';

import '../models/assistant_model.dart';

class AssistantService {
  // get assistant
  Future<String> getAssistant(
      {String? query, bool? isPublished, bool? isFavorite}) async {
    try {
      Map<String, String> param = {
        if (query != null && query.isNotEmpty) 'query': query,
        if (isFavorite != null) 'isFavorite': isFavorite.toString(),
        if (isPublished != null) 'isPublic': isPublished.toString()
      };

      final response = await apiService.getAssistant(param);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Request failed');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // create assistant
  Future<bool> createAssistant(
      {required String name,
      required String instructions,
      required String description}) async {
    try {
      final response = await apiService.createAssistant({
        'assistantName': name,
        'instructions': instructions,
        'description': description,
      });

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // delete assistant
  Future<bool> deleteAssistant(String id) async {
    try {
      final response = await apiService.deleteAssistant(id);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // update assistant
  Future<bool> updateAssistant(String id,
      {required String name,
      required String instructions,
      required String description}) async {
    try {
      final response = await apiService.updateAssistant(id, {
        'assistantName': name,
        'instructions': instructions,
        'description': description,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // create thread
  Future<bool> createThread(
      {required String id, required String message}) async {
    try {
      final response = await apiService.createThread({
        'assistantId': id,
        'firstMessage': message,
      });

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // get all threads
  Future<String> getAllThreads() async {
    try {
      final response = await apiService.getAllThreads(Assistant.currentBot.id);

      if (response.statusCode == 200) {
        return response.body;
      }
      throw (Exception('Request failed'));
    } catch (e) {
      throw Exception(e);
    }
  }

  // get thread message
  Future<String> getThreadMessages(String id) async {
    try {
      final response = await apiService.getThreadMessages(id);

      if (response.statusCode == 200) {
        return response.body;
      }
      throw (Exception('Request failed'));
    } catch (e) {
      throw Exception(e);
    }
  }

  // ask ai
  Future<String> askAssistant(
      {required String assistantId,
      required String threadId,
      required String message}) async {
    try {
      final response = await apiService.askAssistant(assistantId, {
        'message': message,
        'openAiThreadId': threadId,
      });

      var data = response.body;
      print(data);
      print(response.body);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Request Failed');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
