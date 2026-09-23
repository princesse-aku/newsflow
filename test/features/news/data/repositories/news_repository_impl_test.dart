import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newsflow/features/news/data/datasources/news_local_data_source.dart';
import 'package:newsflow/features/news/data/datasources/news_remote_data_source.dart';
import 'package:newsflow/features/news/data/models/article_model.dart';
import 'package:newsflow/features/news/data/models/cached_article_model.dart';
import 'package:newsflow/features/news/data/repositories/news_repository_impl.dart';

class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

class MockNewsLocalDataSource extends Mock implements NewsLocalDataSource {}

void main() {
  late MockNewsRemoteDataSource remoteDataSource;
  late MockNewsLocalDataSource localDataSource;
  late NewsRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockNewsRemoteDataSource();
    localDataSource = MockNewsLocalDataSource();

    repository = NewsRepositoryImpl(remoteDataSource, localDataSource);
  });

  group('NewsRepositoryImpl', () {
    test('getTopHeadlines retourne les articles de l API '
        'et les sauvegarde dans le cache', () async {
      final articles = [
        ArticleModel(
          title: 'Flutter News',
          description: 'Description',
          url: 'https://example.com/flutter',
          imageUrl: 'https://example.com/image.jpg',
          sourceName: 'Tech News',
          publishedAt: DateTime.parse('2026-09-14T10:00:00Z'),
          author: 'Auteur',
          content: 'Contenu',
        ),
      ];

      when(() => remoteDataSource.getTopHeadlines())
          .thenAnswer((_) async => articles);

      when(() => localDataSource.cacheArticles(any())).thenAnswer((_) async {});

      final result = await repository.getTopHeadlines();

      expect(result, hasLength(1));
      expect(result.first.title, 'Flutter News');

      verify(() => remoteDataSource.getTopHeadlines()).called(1);

      verify(() => localDataSource.cacheArticles(any())).called(1);
    });

    test('getTopHeadlines retourne les articles du cache '
        'si l API est indisponible', () async {
      when(() => remoteDataSource.getTopHeadlines()).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/top-headlines')),
      );

      const cachedArticle = CachedArticleModel(
        title: 'Article en cache',
        description: 'Description en cache',
        url: 'https://example.com/cache',
        imageUrl: 'https://example.com/cache.jpg',
        sourceName: 'Tech News',
        publishedAt: '2026-09-14T10:00:00Z',
        author: 'Auteur',
        content: 'Contenu en cache',
      );

      when(() => localDataSource.getCachedArticles())
          .thenReturn([cachedArticle]);

      final result = await repository.getTopHeadlines();

      expect(result, hasLength(1));
      expect(result.first.title, 'Article en cache');
      expect(result.first.sourceName, 'Tech News');

      verify(() => remoteDataSource.getTopHeadlines()).called(1);

      verify(() => localDataSource.getCachedArticles()).called(1);
    });

    test('searchNews retourne les résultats de recherche '
        'et les sauvegarde dans le cache', () async {
      final articles = [
        ArticleModel(
          title: 'Flutter et Firebase',
          description: 'Une actualité Flutter.',
          url: 'https://example.com/flutter-firebase',
          imageUrl: 'https://example.com/image.jpg',
          sourceName: 'Tech News',
          publishedAt: DateTime.parse('2026-09-14T11:00:00Z'),
          author: 'Auteur',
          content: 'Contenu',
        ),
      ];

      when(() => remoteDataSource.searchNews('Flutter'))
          .thenAnswer((_) async => articles);

      when(() => localDataSource.cacheArticles(any())).thenAnswer((_) async {});

      final result = await repository.searchNews('Flutter');

      expect(result, hasLength(1));
      expect(result.first.title, 'Flutter et Firebase');

      verify(() => remoteDataSource.searchNews('Flutter')).called(1);

      verify(() => localDataSource.cacheArticles(any())).called(1);
    });

    test('getTopHeadlines retourne une liste vide '
        'si le cache est vide', () async {
      when(() => remoteDataSource.getTopHeadlines()).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/top-headlines')),
      );

      when(() => localDataSource.getCachedArticles()).thenReturn([]);

      final result = await repository.getTopHeadlines();

      expect(result, isEmpty);

      verify(() => remoteDataSource.getTopHeadlines()).called(1);

      verify(() => localDataSource.getCachedArticles()).called(1);
    });

    test('searchNews retourne les articles du cache '
        'si l API est indisponible', () async {
      when(() => remoteDataSource.searchNews('Flutter')).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/everything')),
      );

      const cachedArticle = CachedArticleModel(
        title: 'Article en cache',
        description: 'Description en cache',
        url: 'https://example.com/cache',
        imageUrl: 'https://example.com/cache.jpg',
        sourceName: 'Tech News',
        publishedAt: '2026-09-14T10:00:00Z',
        author: 'Auteur',
        content: 'Contenu en cache',
      );

      when(() => localDataSource.getCachedArticles())
          .thenReturn([cachedArticle]);

      final result = await repository.searchNews('Flutter');

      expect(result, hasLength(1));
      expect(result.first.title, 'Article en cache');
      expect(result.first.description, 'Description en cache');
      expect(result.first.sourceName, 'Tech News');

      verify(() => remoteDataSource.searchNews('Flutter')).called(1);

      verify(() => localDataSource.getCachedArticles()).called(1);
    });

    test('searchNews retourne une liste vide '
        'lorsque le cache est vide', () async {
      when(() => remoteDataSource.searchNews('Flutter')).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/everything')),
      );

      when(() => localDataSource.getCachedArticles()).thenReturn([]);

      final result = await repository.searchNews('Flutter');

      expect(result, isEmpty);

      verify(() => remoteDataSource.searchNews('Flutter')).called(1);

      verify(() => localDataSource.getCachedArticles()).called(1);
    });
  });
}
