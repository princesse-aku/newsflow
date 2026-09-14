import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:newsflow/features/news/data/datasources/news_local_data_source.dart';
import 'package:newsflow/features/news/data/datasources/news_remote_data_source.dart';
import 'package:newsflow/features/news/data/models/article_model.dart';
import 'package:newsflow/features/news/data/models/cached_article_model.dart';
import 'package:newsflow/features/news/data/repositories/news_repository_impl.dart';

class MockNewsRemoteDataSource extends Mock
    implements NewsRemoteDataSource {}

class MockNewsLocalDataSource extends Mock
    implements NewsLocalDataSource {}

void main() {
  late MockNewsRemoteDataSource remoteDataSource;
  late MockNewsLocalDataSource localDataSource;
  late NewsRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockNewsRemoteDataSource();
    localDataSource = MockNewsLocalDataSource();

    repository = NewsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  test(
    'getTopHeadlines retourne les articles de l API '
    'et les sauvegarde dans le cache',
    () async {
      final articles = [
        const ArticleModel(
          title: 'Flutter progresse encore',
          description: 'Une actualité sur Flutter.',
          url: 'https://example.com/flutter',
          imageUrl: '',
          sourceName: 'Example News',
          publishedAt: null,
          author: 'Auteur',
          content: 'Contenu de l article.',
        ),
      ];

      when(
        () => remoteDataSource.getTopHeadlines(),
      ).thenAnswer((_) async => articles);

      when(
        () => localDataSource.cacheArticles(any()),
      ).thenAnswer((_) async {});

      final result = await repository.getTopHeadlines();

      expect(result, hasLength(1));
      expect(result.first.title, 'Flutter progresse encore');

      verify(
        () => remoteDataSource.getTopHeadlines(),
      ).called(1);

      verify(
        () => localDataSource.cacheArticles(
          any(that: isA<List<CachedArticleModel>>()),
        ),
      ).called(1);
    },
  );

  test(
    'getTopHeadlines retourne les articles du cache '
    'si l API est indisponible',
    () async {
      final cachedArticles = [
        const CachedArticleModel(
          title: 'Article hors ligne',
          description: 'Article disponible dans le cache.',
          url: 'https://example.com/offline',
          imageUrl: '',
          sourceName: 'Offline News',
          publishedAt: null,
          author: 'Auteur',
          content: 'Contenu en cache.',
        ),
      ];

      when(
        () => remoteDataSource.getTopHeadlines(),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: '/top-headlines',
          ),
        ),
      );

      when(
        () => localDataSource.getCachedArticles(),
      ).thenReturn(cachedArticles);

      final result = await repository.getTopHeadlines();

      expect(result, hasLength(1));
      expect(result.first.title, 'Article hors ligne');
      expect(
        result.first.description,
        'Article disponible dans le cache.',
      );

      verify(
        () => remoteDataSource.getTopHeadlines(),
      ).called(1);

      verify(
        () => localDataSource.getCachedArticles(),
      ).called(1);

      verifyNever(
        () => localDataSource.cacheArticles(any()),
      );
    },
  );

    test(
    'searchNews retourne les résultats de recherche '
    'et les sauvegarde dans le cache',
    () async {
      final articles = [
        const ArticleModel(
          title: 'Actualité sur l intelligence artificielle',
          description: 'Une actualité sur l IA.',
          url: 'https://example.com/ia',
          imageUrl: '',
          sourceName: 'Tech News',
          publishedAt: null,
          author: 'Auteur',
          content: 'Contenu de l article sur l IA.',
        ),
      ];

      when(
        () => remoteDataSource.searchNews('intelligence artificielle'),
      ).thenAnswer((_) async => articles);

      when(
        () => localDataSource.cacheArticles(any()),
      ).thenAnswer((_) async {});

      final result = await repository.searchNews(
        'intelligence artificielle',
      );

      expect(result, hasLength(1));
      expect(
        result.first.title,
        'Actualité sur l intelligence artificielle',
      );

      verify(
        () => remoteDataSource.searchNews(
          'intelligence artificielle',
        ),
      ).called(1);

      verify(
        () => localDataSource.cacheArticles(
          any(that: isA<List<CachedArticleModel>>()),
        ),
      ).called(1);
    },
  );
}