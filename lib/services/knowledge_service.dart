import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:jarvis_project/services/api_service.dart';

class KnowledgeService {
  // get knowledge
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

  // create knowledge
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

  // delete knowledge
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

  // update knowledge
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

  // get knowledge unit
  Future<String> getKnowledgeUnit(String id) async {
    try {
      final response = await apiService.getKnowledgeUnit(id);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Request failed');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // add website
  Future<bool> addWebsiteToKnowledge(
      {required String id, required String name, required String url}) async {
    try {
      final response = await apiService.addWebsiteToKnowledge(id, {
        'unitName': name,
        'webUrl': url,
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

  // add website
  Future<bool> addFileToKnowledge(String id) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      File file;
      if (result != null) {
        file = File(result.files.single.path!);
      } else {
        throw Exception('No file selected');
      }

      final response = await apiService.addFileToKnowledge(id, file);

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // add slack
  Future<bool> addSlackToKnowledge(
      {required String id,
      required String name,
      required String workspace,
      required String token}) async {
    try {
      final response = await apiService.addDataFromSlack(id, {
        'unitName': name,
        'slackWorkspace': workspace,
        'slackBotToken': token
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

  // add confluence
  Future<bool> addConfluenceToKnowledge(
      {required String id,
      required String name,
      required String page,
      required String username,
      required String token}) async {
    try {
      final response = await apiService.addDataFromSlack(id, {
        'unitName': name,
        'wikiPageUrl': page,
        'confluenceUsername': username,
        'confluenceAccessToken': token
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
}
