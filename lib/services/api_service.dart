import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvis_project/util/endpoints.dart';

import '../models/user_model.dart';

final ApiService apiService = ApiService();

final class ApiService {
  static const baseURL = 'https://api.dev.jarvis.cx';

  // ---------- Auth ----------
  // sign-in
  Future<http.Response> signIn(Map<String, String> data) async {
    // url
    var url = baseURL + authEndpoints['signIn']!;

    // request
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // get user
  Future<http.Response> getUser() async {
    // url
    var url = baseURL + authEndpoints['getUser']!;

    // request
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.refreshToken}'
      });
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // refresh token
  Future<http.Response> refreshToken() async {
    // url
    var url = baseURL + authEndpoints['refreshToken']!;

    // request
    try {
      final response = await http.get(
          Uri.parse(url)
              .replace(queryParameters: {'refreshToken': User.refreshToken}),
          headers: {'Content-Type': 'application/json'});
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // sign-up
  Future<http.Response> signUp(Map<String, String> data) async {
    // url
    var url = baseURL + authEndpoints['signUp']!;

    // request
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // sign out
  Future<http.Response> signOut() async {
    // url
    var url = baseURL + authEndpoints['signOut']!;

    // request
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.refreshToken}'
      });
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // ---------- AI chat ----------
  // send message
  Future<http.Response> sendMessage(String body) async {
    // url
    var url = baseURL + chatEndpoints['sendMessage']!;

    // request
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${User.refreshToken}'
          },
          body: body);
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // load all conversations
  Future<http.Response> getAllConversation(Map<String, String> param) async {
    // url
    var url = baseURL + chatEndpoints['getAllConversations']!;

    // request
    try {
      final response = await http
          .get(Uri.parse(url).replace(queryParameters: param), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.refreshToken}'
      });
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // load conversation
  Future<http.Response> loadConversation(
      String id, Map<String, String> param) async {
    // url
    var url = baseURL + chatEndpoints['getConversationHistory']!;

    // request
    try {
      final response = await http.get(
          Uri.parse('$url$id/messages').replace(queryParameters: param),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${User.refreshToken}'
          });
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // ---------- prompts ----------
  // get prompts
  Future<http.Response> getPrompt(Map<String, String> param) async {
    // url
    var url = baseURL + promptEndpoints['getPrompt']!;

    print(param);
    print(param.runtimeType);
    // request
    try {
      final response = await http
          .get(Uri.parse(url).replace(queryParameters: param), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${User.refreshToken}'
      });
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // add to favorite
  Future<http.Response> addToFavorite(String id) async {
    // url
    var url = baseURL + promptEndpoints['addPromptToFavorite']!;

    // request
    try {
      final response = await http.post(
        Uri.parse('$url$id/favorite'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.refreshToken}'
        },
      );
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // remove from favorite
  Future<http.Response> removeFromFavorite(String id) async {
    // url
    var url = baseURL + promptEndpoints['removePromptFromFavorite']!;

    // request
    try {
      final response = await http.delete(
        Uri.parse('$url$id/favorite'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${User.refreshToken}'
        },
      );
      return response;
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }
}
