import 'package:flutter_test/flutter_test.dart';
import 'package:newsflow/features/news/data/models/article_model.dart';

void main() {
  group('ArticleModel.fromJson', () {
    test('convertit correctement un JSON complet en ArticleModel', () {
      final json = {
        'title': 'Flutter et Firebase',
        'description': 'Une actualité sur Flutter et Firebase.',
        'url': 'https://example.com/article',
        'urlToImage': 'https://example.com/image.jpg',
        'source': {'name': 'Tech News'},
        'publishedAt': '2026-09-14T10:30:00Z',
        'author': 'Tech Princess',
        'content': 'Contenu de l article.',
      };

      final article = ArticleModel.fromJson(json);

      expect(article.title, 'Flutter et Firebase');
      expect(article.description, 'Une actualité sur Flutter et Firebase.');
      expect(article.url, 'https://example.com/article');
      expect(article.imageUrl, 'https://example.com/image.jpg');
      expect(article.sourceName, 'Tech News');
      expect(article.author, 'Tech Princess');
      expect(article.content, 'Contenu de l article.');
      expect(article.publishedAt, DateTime.parse('2026-09-14T10:30:00Z'));
    });

    test('utilise des chaînes vides lorsque les valeurs sont absentes', () {
      final json = <String, dynamic>{};

      final article = ArticleModel.fromJson(json);

      expect(article.title, '');
      expect(article.description, '');
      expect(article.url, '');
      expect(article.imageUrl, '');
      expect(article.sourceName, '');
      expect(article.author, '');
      expect(article.content, '');
      expect(article.publishedAt, isNull);
    });

    test('convertit correctement une date valide', () {
      final json = {
        'title': 'Article test',
        'publishedAt': '2026-09-14T12:00:00Z',
      };

      final article = ArticleModel.fromJson(json);

      expect(article.publishedAt, DateTime.parse('2026-09-14T12:00:00Z'));
    });

    test('retourne null pour une date invalide', () {
      final json = {'title': 'Article test', 'publishedAt': 'date-invalide'};

      final article = ArticleModel.fromJson(json);

      expect(article.publishedAt, isNull);
    });
  });
}
