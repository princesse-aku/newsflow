import 'package:flutter_test/flutter_test.dart';
import 'package:newsflow/features/news/data/models/cached_article_model.dart';

void main() {
  group('CachedArticleModel', () {
    const article = CachedArticleModel(
      title: 'Flutter News',
      description: 'Une actualité Flutter.',
      url: 'https://example.com/article',
      imageUrl: 'https://example.com/image.jpg',
      sourceName: 'Tech News',
      publishedAt: '2026-09-14T10:30:00Z',
      author: 'Tech Princess',
      content: 'Contenu de test.',
    );

    test('toMap retourne correctement toutes les données', () {
      final map = article.toMap();

      expect(map['title'], 'Flutter News');
      expect(map['description'], 'Une actualité Flutter.');
      expect(map['url'], 'https://example.com/article');
      expect(map['imageUrl'], 'https://example.com/image.jpg');
      expect(map['sourceName'], 'Tech News');
      expect(map['publishedAt'], '2026-09-14T10:30:00Z');
      expect(map['author'], 'Tech Princess');
      expect(map['content'], 'Contenu de test.');
    });

    test('fromMap reconstruit correctement un article', () {
      final map = {
        'title': 'Flutter News',
        'description': 'Une actualité Flutter.',
        'url': 'https://example.com/article',
        'imageUrl': 'https://example.com/image.jpg',
        'sourceName': 'Tech News',
        'publishedAt': '2026-09-14T10:30:00Z',
        'author': 'Tech Princess',
        'content': 'Contenu de test.',
      };

      final result = CachedArticleModel.fromMap(map);

      expect(result.title, article.title);
      expect(result.description, article.description);
      expect(result.url, article.url);
      expect(result.imageUrl, article.imageUrl);
      expect(result.sourceName, article.sourceName);
      expect(result.publishedAt, article.publishedAt);
      expect(result.author, article.author);
      expect(result.content, article.content);
    });

    test('fromMap utilise des valeurs par défaut lorsque les données manquent', () {
      final map = <String, dynamic>{};

      final result = CachedArticleModel.fromMap(map);

      expect(result.title, '');
      expect(result.description, '');
      expect(result.url, '');
      expect(result.imageUrl, '');
      expect(result.sourceName, '');
      expect(result.publishedAt, isNull);
      expect(result.author, '');
      expect(result.content, '');
    });

    test('toMap conserve publishedAt à null', () {
      const articleWithoutDate = CachedArticleModel(
        title: 'Article sans date',
        description: 'Description',
        url: 'https://example.com',
        imageUrl: '',
        sourceName: 'Tech News',
        publishedAt: null,
        author: '',
        content: '',
      );

      final map = articleWithoutDate.toMap();

      expect(map['publishedAt'], isNull);
    });
  });
}