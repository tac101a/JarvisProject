class Message {
  late String role;
  late String createdAt;
  late String content;

  Message(this.role, int createdAt, this.content) {
    var date = DateTime.fromMillisecondsSinceEpoch(createdAt);
    this.createdAt = date.toString();
  }
}
