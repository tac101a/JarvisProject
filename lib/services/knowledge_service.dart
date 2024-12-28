import 'dart:convert';

import 'package:jarvis_project/services/api_service.dart';

class KnowledgeService {
  // get assistant
  Future<String> getKnowledge() async {
    try {
      final response = await apiService.getKnowledge();

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
  Future<bool> createKnowledge(
      {required String name, required String description}) async {
    try {
      final response = await apiService.createKnowledge({
        'knowledgeName': name,
        'description': description,
      });

      var data = json.decode(response.body);
      print(data);

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
  Future<bool> deleteKnowledge(String id) async {
    try {
      final response = await apiService.deleteKnowledge(id);

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
  Future<bool> updateKnowledge(String id,
      {required String name, required String description}) async {
    try {
      final response = await apiService.updateKnowledge(id, {
        'knowledgeName': name,
        'description': description,
      });

      var data = json.decode(response.body);
      print(data);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
