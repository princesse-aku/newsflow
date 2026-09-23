import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../../news/domain/entities/article.dart';

final favoritesLocalDataSourceProvider =
    Provider<FavoritesLocalDataSource>((ref) {
  final box = Hive.box<dynamic>('news_cache');

  return FavoritesLocalDataSource(box);
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(
    ref.watch(favoritesLocalDataSourceProvider),
  );
});

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<Article>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends Notifier<List<Article>> {
  late final FavoritesRepository _repository;

  @override
  List<Article> build() {
    _repository = ref.read(favoritesRepositoryProvider);

    return _repository.getFavorites();
  }

  bool isFavorite(Article article) {
    return state.any(
      (favorite) => favorite.url == article.url,
    );
  }

  Future<void> toggleFavorite(Article article) async {
    if (isFavorite(article)) {
      state = state
          .where((favorite) => favorite.url != article.url)
          .toList();
    } else {
      state = [...state, article];
    }

    await _repository.saveFavorites(state);
  }

  Future<void> removeFavorite(Article article) async {
    state = state
        .where((favorite) => favorite.url != article.url)
        .toList();

    await _repository.saveFavorites(state);
  }

  Future<void> clearFavorites() async {
    state = [];

    await _repository.clearFavorites();
  }
}
