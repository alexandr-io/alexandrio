class Book {
  final String id;
  final String title;
  final String? author;
  final String? description;
  final String? thumbnail;

  Book({
    required this.id,
    required this.title,
    this.author,
    this.description,
    this.thumbnail,
  });
}
