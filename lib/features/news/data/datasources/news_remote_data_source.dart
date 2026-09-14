import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/article_model.dart';

class NewsRemoteDataSource {
  NewsRemoteDataSource({
    required DioClient dioClient,
  }) : _dio = dioClient.dio;

  final Dio _dio;

  Future<List<ArticleModel>> getTopHeadlines() async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'us',
        },
        options: Options(
          headers: {
            'X-Api-Key': AppConfig.newsApiKey,
          },
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final articles = data['articles'] as List<dynamic>? ?? [];

      return articles
          .whereType<Map<String, dynamic>>()
          .map(ArticleModel.fromJson)
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception(
        'Impossible de traiter les données des actualités.',
      );
    }
  }

  Future<List<ArticleModel>> searchNews(String query) async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'q': query,
          'language': 'fr',
          'sortBy': 'publishedAt',
        },
        options: Options(
          headers: {
            'X-Api-Key': AppConfig.newsApiKey,
          },
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final articles = data['articles'] as List<dynamic>? ?? [];

      return articles
          .whereType<Map<String, dynamic>>()
          .map(ArticleModel.fromJson)
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception(
        'Impossible de traiter les résultats de recherche.',
      );
    }
  }
}