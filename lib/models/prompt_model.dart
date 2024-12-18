class Prompt {
  late String id;
  late String category;
  late String content;
  late String description;
  late String title;
  late bool isPublic;
  late bool isFavorite;

  Prompt(this.id, this.category, this.content, this.description, this.title,
      this.isPublic, this.isFavorite);
}
