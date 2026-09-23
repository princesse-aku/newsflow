import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/optimized_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../news/domain/entities/article.dart';
import '../../../news/presentation/screens/article_detail_screen.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
        actions: [
          _ClearFavoritesButton(
            visible: favorites.isNotEmpty,
          ),
        ],
      ),
      body: favorites.isEmpty
          ? const _EmptyFavorites()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                return _FavoriteArticleCard(
                  article: favorites[index],
                );
              },
            ),
    );
  }
}

class _ClearFavoritesButton extends ConsumerWidget {
  const _ClearFavoritesButton({
    required this.visible,
  });

  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      label: l10n.clearFavorites,
      child: IconButton(
        onPressed: () {
          _showClearConfirmation(context, ref);
        },
        tooltip: l10n.clearFavorites,
        icon: const Icon(Icons.delete_outline),
      ),
    );
  }

  void _showClearConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.clearFavoritesTitle),
          content: Text(l10n.clearFavoritesMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await ref
                    .read(favoritesProvider.notifier)
                    .clearFavorites();
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star_border,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noFavorites,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addFavoritesToFindThemHere,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteArticleCard extends ConsumerWidget {
  const _FavoriteArticleCard({
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      label: l10n.favoriteArticle(article.title),
      hint: l10n.readArticleHint,
      child: Card(
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
                  Semantics(
                    excludeSemantics: true,
                    child: OptimizedNetworkImage(
                      imageUrl: article.imageUrl,
                      width: 110,
                      height: 90,
                      borderRadius: 8,
                    ),
                  ),
                if (article.imageUrl.isNotEmpty)
                  const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                Semantics(
                  button: true,
                  label: l10n.removeFavoriteArticle(
                    article.title,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      await ref
                          .read(favoritesProvider.notifier)
                          .removeFavorite(article);
                    },
                    tooltip: l10n.removeFromFavorites,
                    icon: const Icon(
                      Icons.star,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}