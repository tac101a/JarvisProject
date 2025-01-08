class EmailReplyResponse {
  final String email;
  final int remainingUsage;

  EmailReplyResponse({
    required this.email,
    required this.remainingUsage,
  });

  factory EmailReplyResponse.fromJson(Map<String, dynamic> json) {
    return EmailReplyResponse(
      email: json['email'] as String,
      remainingUsage: json['remainingUsage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'remainingUsage': remainingUsage,
    };
  }
}
