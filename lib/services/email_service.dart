import 'dart:convert';
import 'package:jarvis_project/models/email_reply.dart';
import 'package:jarvis_project/models/email_reply_response.dart';
import 'package:jarvis_project/services/api_service.dart';
import 'package:jarvis_project/models/user_model.dart';
import 'package:flutter/foundation.dart';

class MailService {
  final ApiService _apiService = ApiService();

  /// Hàm để gọi API tạo email draft
  Future<EmailReplyResponse> generateResponseEmail(
      EmailReply emailReply) async {
    // Kiểm tra token trước khi thực hiện request
    if (User.refreshToken.isEmpty) {
      throw Exception('User is not authenticated. Refresh token is missing.');
    }

    // In payload khi debug
    if (kDebugMode) {
      print('Payload: ${json.encode(emailReply.toJson())}');
    }

    try {
      // Gọi phương thức `responseEmail` từ `ApiService`
      final response = await _apiService.responseEmail(emailReply);

      // Kiểm tra response
      if (response.statusCode == 200) {
        return EmailReplyResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Authentication error: ${response.body}');
      } else {
        final error =
            json.decode(response.body)['message'] ?? 'Unknown error occurred';
        throw Exception('Failed to generate response email: $error');
      }
    } catch (e) {
      throw Exception('Error generating response email: $e');
    }
  }

  Future<List<String>> getReplyIdeas(EmailReply emailReply) async {
    if (User.refreshToken.isEmpty) {
      throw Exception('User is not authenticated. Refresh token is missing.');
    }

    final payload = {
      "action": "Suggest 3 ideas for this email",
      "email": emailReply.email,
      "metadata": emailReply.metadata.toJson(),
    };

    print('Payload: ${json.encode(payload)}');

    try {
      final response = await _apiService.suggestReplyIdeas(payload);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['ideas'] as List<dynamic>).cast<String>();
      } else {
        throw Exception('Failed to get reply ideas: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting reply ideas: $e');
    }
  }
}
