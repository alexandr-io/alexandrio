class Book {
  final String id;
  final String title;
  final String? author;
  final String? description;

  Book({
    required this.id,
    required this.title,
    this.author,
    this.description,
  });
}
