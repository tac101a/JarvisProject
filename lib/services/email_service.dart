import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvis_project/models/email_reply.dart';
import 'package:jarvis_project/models/email_reply_response.dart';
import 'package:jarvis_project/util/endpoints.dart';
import 'package:jarvis_project/services/api_service.dart';
import 'package:jarvis_project/models/user_model.dart';

class MailService {
  Future<EmailReplyResponse> generateResponseEmail(
      EmailReply emailReply) async {
    final url = '${ApiService.baseURL}${emailEndpoints['responseEmail']}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${User.refreshToken}', // Đảm bảo token chính xác
        },
        body: json.encode(emailReply.toJson()),
      );

      if (response.statusCode == 200) {
        return EmailReplyResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to generate response email: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating response email: $e');
    }
  }
}
