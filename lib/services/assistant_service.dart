import 'package:jarvis_project/services/api_service.dart';

class AssistantService {
  Future<String> getAssistant(
      {String? query, bool? isPublished, bool? isFavorite}) async {
    try {
      Map<String, String> param = {
        if (query != null && query.isNotEmpty) 'query': query,
        if (isFavorite != null) 'isFavorite': isFavorite.toString(),
        if (isPublished != null) 'isPublic': isPublished.toString()
      };

      print(param);
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
}
