import 'dart:convert';

import 'api_service.dart';

class EmailService {
  Future<List<String>> getSuggestedReplies(String email, String subject) async {
    try {
      Map<String, dynamic> body = {
        "action": "Suggest 3 ideas for this email",
        "email": email,
        "metadata": {
          "context": [],
          "subject": subject,
          "sender": "example@domain.com",
          "receiver": "receiver@domain.com",
          "language": "vietnamese"
        }
      };
      final response = await apiService.suggestReplyIdeas(body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['ideas']);
      } else {
        throw Exception('Failed to fetch suggested replies');
      }
    } catch (e) {
      throw Exception('Error fetching suggested replies: $e');
    }
  }

  Future<String> generateResponseEmail(
      String mainIdea, String emailContent) async {
    try {
      Map<String, dynamic> body = {
        "mainIdea": mainIdea,
        "action": "Reply to this email",
        "email": emailContent,
        "metadata": {
          "context": [],
          "subject": "Email Subject",
          "sender": "example@domain.com",
          "receiver": "receiver@domain.com",
          "style": {
            "length": "long",
            "formality": "neutral",
            "tone": "friendly"
          },
          "language": "vietnamese"
        }
      };
      final response = await apiService.responseEmail(body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['email'];
      } else {
        throw Exception('Failed to generate response email');
      }
    } catch (e) {
      throw Exception('Error generating email: $e');
    }
  }
}
