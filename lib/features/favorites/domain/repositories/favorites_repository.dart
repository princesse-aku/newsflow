import '../../../news/domain/entities/article.dart';

abstract class FavoritesRepository {
  List<Article> getFavorites();

  Future<void> saveFavorites(List<Article> articles);

  Future<void> clearFavorites();
}