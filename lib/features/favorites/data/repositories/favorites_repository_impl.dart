import '../../../news/data/models/cached_article_model.dart';
import '../../../news/domain/entities/article.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._localDataSource);
  final FavoritesLocalDataSource _localDataSource;

  @override
  List<Article> getFavorites() {
    return _localDataSource.getFavorites().map(_fromCachedArticle).toList();
  }

  @override
  Future<void> saveFavorites(List<Article> articles) async {
    final cachedArticles = articles.map(_toCachedArticle).toList();

    await _localDataSource.saveFavorites(cachedArticles);
  }

  @override
  Future<void> clearFavorites() async {
    await _localDataSource.clearFavorites();
  }

  CachedArticleModel _toCachedArticle(Article article) {
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
