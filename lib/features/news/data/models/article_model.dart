import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.title,
    required super.description,
    required super.url,
    required super.imageUrl,
    required super.sourceName,
    required super.publishedAt,
    required super.author,
    required super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>?;

    return ArticleModel(
      title: _stringValue(json['title']),
      description: _stringValue(json['description']),
      url: _stringValue(json['url']),
      imageUrl: _stringValue(json['urlToImage']),
      sourceName: _stringValue(source?['name']),
      publishedAt: _parseDate(json['publishedAt']),
      author: _stringValue(json['author']),
      content: _stringValue(json['content']),
    );
  }

  static String _stringValue(dynamic value) {
    if (value is String) {
      return value;
    }

    return '';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }
}