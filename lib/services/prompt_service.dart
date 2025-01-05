import 'dart:convert';

import 'api_service.dart';

class PromptService {
  // get prompt
  Future<String> getPrompt({String? query,
    String? category,
    bool? isPublic,
    bool? isFavorite}) async {
    try {
      Map<String, String> param = {
        if (query != null && query.isNotEmpty) 'query': query,
        if (category != null) 'category': category.toLowerCase(),
        if (isFavorite != null) 'isFavorite': isFavorite.toString(),
        if (isPublic != null) 'isPublic': isPublic.toString()
      };

      final response = await apiService.getPrompt(param);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Request failed');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // add to favorite
  Future<bool> addToFavorite(String id) async {
    try {
      final response = await apiService.addToFavorite(id);

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // remove from favorite
  Future<bool> removeFromFavorite(String id) async {
    try {
      final response = await apiService.removeFromFavorite(id);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // create new prompt
  Future<bool> createPrompt({required String title,
    required String language,
    required String category,
    required bool isPublic,
    required String description,
    required String content}) async {
    try {
      final response = await apiService.createPrompt({
        'title': title,
        'language': language,
        'category': category.toLowerCase(),
        'isPublic': isPublic,
        'description': description,
        'content': content,
      });

      if (response.statusCode == 201) {
        print('create prompt success');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // delete prompt
  Future<bool> deletePrompt(String id) async {
    try {
      final response = await apiService.deletePrompt(id);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // update prompt
  Future<bool> updatePrompt(String id,
      {required String title,
        required String language,
        required String category,
        required bool isPublic,
        required String description,
        required String content}) async {
    try {
      final response = await apiService.updatePrompt(id, {
        'title': title,
        'language': language,
        'category': category.toLowerCase(),
        'isPublic': isPublic,
        'description': description,
        'content': content,
      });

      if (response.statusCode == 200) {
        print('update prompt success');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
