import 'package:dio/dio.dart';

import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/article_model.dart';
import '../models/cached_article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl({
    required NewsRemoteDataSource remoteDataSource,
    required NewsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final NewsRemoteDataSource _remoteDataSource;
  final NewsLocalDataSource _localDataSource;

  @override
  Future<List<Article>> getTopHeadlines() async {
    try {
      final articles = await _remoteDataSource.getTopHeadlines();

      await _localDataSource.cacheArticles(
        articles.map(_toCachedArticle).toList(),
      );

      return articles;
    } on DioException {
      return _getCachedArticles();
    }
  }

  @override
  Future<List<Article>> searchNews(String query) async {
    try {
      final articles = await _remoteDataSource.searchNews(query);

      await _localDataSource.cacheArticles(
        articles.map(_toCachedArticle).toList(),
      );

      return articles;
    } on DioException {
      return _getCachedArticles();
    }
  }

  List<Article> _getCachedArticles() {
    return _localDataSource
        .getCachedArticles()
        .map(_fromCachedArticle)
        .toList();
  }

  CachedArticleModel _toCachedArticle(ArticleModel article) {
    return CachedArticleModel(
      title: article.title,
      description: article.description,
      url: article.url,
      imageUrl: article.imageUrl,
      sourceName: article.sourceName,
      publishedAt: article.publishedAt?.toIso8601String(),
      author: article.author,
      content: article.content,
    );
  }

  Article _fromCachedArticle(CachedArticleModel article) {
    return Article(
      title: article.title,
      description: article.description,
      url: article.url,
      imageUrl: article.imageUrl,
      sourceName: article.sourceName,
      publishedAt: article.publishedAt == null
          ? null
          : DateTime.tryParse(article.publishedAt!),
      author: article.author,
      content: article.content,
    );
  }
}