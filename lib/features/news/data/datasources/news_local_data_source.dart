import 'package:hive_flutter/hive_flutter.dart';

import '../models/cached_article_model.dart';

class NewsLocalDataSource {
  NewsLocalDataSource({
    required Box<dynamic> box,
  }) : _box = box;

  final Box<dynamic> _box;

  static const String articlesKey = 'cached_articles';

  Future<void> cacheArticles(
    List<CachedArticleModel> articles,
  ) async {
    final articlesData = articles
        .map((article) => article.toMap())
        .toList();

    await _box.put(articlesKey, articlesData);
  }

  List<CachedArticleModel> getCachedArticles() {
    final cachedData = _box.get(articlesKey);

    if (cachedData is! List) {
      return [];
    }

    return cachedData
        .whereType<Map>()
        .map(
          (article) => CachedArticleModel.fromMap(article),
        )
        .toList();
  }

  Future<void> clearCache() async {
    await _box.delete(articlesKey);
  }
}