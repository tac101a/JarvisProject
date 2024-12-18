import 'api_service.dart';

class PromptService {
  // get prompt
  Future<String> getPrompt(
      {String? query,
      String? category,
      bool? isPublic,
      bool? isFavorite}) async {
    try {
      Map<String, String> param = {
        if (query != null && query.isNotEmpty) 'query': query,
        if (category != null) 'category': category,
        if (isFavorite != null) 'isFavorite': isFavorite.toString(),
        if (isPublic != null) 'isPublic': isPublic.toString()
      };

      print(param);
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
}
