class CachedArticleModel {
  const CachedArticleModel({
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
  final String? publishedAt;
  final String author;
  final String content;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'sourceName': sourceName,
      'publishedAt': publishedAt,
      'author': author,
      'content': content,
    };
  }

  factory CachedArticleModel.fromMap(Map<dynamic, dynamic> map) {
    return CachedArticleModel(
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      url: map['url'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      sourceName: map['sourceName'] as String? ?? '',
      publishedAt: map['publishedAt'] as String?,
      author: map['author'] as String? ?? '',
      content: map['content'] as String? ?? '',
    );
  }
}