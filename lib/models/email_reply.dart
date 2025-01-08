class EmailReply {
  String? mainIdea;
  final String action;
  String email;
  final EmailMetadata metadata;

  EmailReply({
    this.mainIdea,
    required this.action,
    required this.email,
    required this.metadata,
  });

  factory EmailReply.fromJson(Map<String, dynamic> json) {
    return EmailReply(
      mainIdea: json['mainIdea'] as String?,
      action: json['action'] as String,
      email: json['email'] as String,
      metadata: EmailMetadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainIdea': mainIdea,
      'action': action,
      'email': email,
      'metadata': metadata.toJson(),
    };
  }
}

class EmailMetadata {
  final List<EmailContent> context;
  final String? subject;
  final String? sender;
  final String? receiver;
  final String? language;
  final EmailStyle style;

  EmailMetadata({
    required this.context,
    this.subject,
    this.sender,
    this.receiver,
    this.language,
    required this.style,
  });

  factory EmailMetadata.fromJson(Map<String, dynamic> json) {
    return EmailMetadata(
      context: (json['context'] as List<dynamic>)
          .map((e) => EmailContent.fromJson(e))
          .toList(),
      subject: json['subject'] as String?,
      sender: json['sender'] as String?,
      receiver: json['receiver'] as String?,
      language: json['language'] as String?,
      style: EmailStyle.fromJson(json['style']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'context': context.map((e) => e.toJson()).toList(),
      'subject': subject,
      'sender': sender,
      'receiver': receiver,
      'language': language,
      'style': style.toJson(),
    };
  }
}

class EmailContent {
  final String subject;
  final String sender;
  final String receiver;
  final String content;

  EmailContent({
    required this.subject,
    required this.sender,
    required this.receiver,
    required this.content,
  });

  factory EmailContent.fromJson(Map<String, dynamic> json) {
    return EmailContent(
      subject: json['subject'] as String,
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'sender': sender,
      'receiver': receiver,
      'content': content,
    };
  }
}

class EmailStyle {
  final String tone;
  final String formality;
  final String length;

  EmailStyle({
    required this.tone,
    required this.formality,
    required this.length,
  });

  factory EmailStyle.fromJson(Map<String, dynamic> json) {
    return EmailStyle(
      tone: json['tone'] as String,
      formality: json['formality'] as String,
      length: json['length'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tone': tone,
      'formality': formality,
      'length': length,
    };
  }
}
