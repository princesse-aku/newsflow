class Article {
  const Article({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
    required this.author,
    required this.content,
  });

  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String sourceName;
  final DateTime? publishedAt;
  final String author;
  final String content;
}