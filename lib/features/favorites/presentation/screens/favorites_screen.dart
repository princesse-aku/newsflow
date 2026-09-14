import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../news/presentation/screens/article_detail_screen.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes favoris'),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              onPressed: () {
                _showClearConfirmation(context, ref);
              },
              tooltip: 'Supprimer tous les favoris',
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_border,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Aucun favori',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ajoutez des articles à vos favoris '
                      'pour les retrouver ici.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                final article = favorites[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ArticleDetailScreen(
                            article: article,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article.imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                article.imageUrl,
                                width: 110,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return const SizedBox(
                                    width: 110,
                                    height: 90,
                                    child: Center(
                                      child: Icon(
                                        Icons
                                            .image_not_supported_outlined,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (article.imageUrl.isNotEmpty)
                            const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                if (article.sourceName.isNotEmpty)
                                  Text(
                                    article.sourceName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                const SizedBox(height: 6),
                                Text(
                                  article.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await ref
                                  .read(favoritesProvider.notifier)
                                  .removeFavorite(article);
                            },
                            tooltip: 'Retirer des favoris',
                            icon: const Icon(
                              Icons.star,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showClearConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer les favoris ?'),
          content: const Text(
            'Tous vos articles favoris seront supprimés.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await ref
                    .read(favoritesProvider.notifier)
                    .clearFavorites();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}