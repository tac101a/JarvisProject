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
      metadata:
          EmailMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
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
  final String? subject;
  final String? sender;
  final String? receiver;
  final String? language;
  final EmailStyle? style;

  EmailMetadata({
    this.subject,
    this.sender,
    this.receiver,
    this.language,
    this.style,
  });

  factory EmailMetadata.fromJson(Map<String, dynamic> json) {
    return EmailMetadata(
      subject: json['subject'] as String?,
      sender: json['sender'] as String?,
      receiver: json['receiver'] as String?,
      language: json['language'] as String?,
      style: json['style'] != null
          ? EmailStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'sender': sender,
      'receiver': receiver,
      'language': language,
      'style': style?.toJson(),
    };
  }
}

class EmailStyle {
  final String? tone;
  final String? formality;
  final String? length;

  EmailStyle({this.tone, this.formality, this.length});

  factory EmailStyle.fromJson(Map<String, dynamic> json) {
    return EmailStyle(
      tone: json['tone'] as String?,
      formality: json['formality'] as String?,
      length: json['length'] as String?,
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
