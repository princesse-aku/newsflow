import 'package:hive_flutter/hive_flutter.dart';

import '../../../news/data/models/cached_article_model.dart';

class FavoritesLocalDataSource {
  FavoritesLocalDataSource(this._box);
  final Box<dynamic> _box;

  static const String favoritesKey = 'favorite_articles';

  List<CachedArticleModel> getFavorites() {
    final cachedData = _box.get(favoritesKey);

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

  Future<void> saveFavorites(
    List<CachedArticleModel> articles,
  ) async {
    final articlesData = articles
        .map((article) => article.toMap())
        .toList();

    await _box.put(favoritesKey, articlesData);
  }

  Future<void> clearFavorites() async {
    await _box.delete(favoritesKey);
  }
}