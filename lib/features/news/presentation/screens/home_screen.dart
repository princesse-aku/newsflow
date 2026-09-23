import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/optimized_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../domain/entities/article.dart';
import '../providers/top_headlines_provider.dart';
import 'article_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final headlinesState = ref.watch(topHeadlinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Semantics(
            button: true,
            label: l10n.searchNews,
            hint: l10n.searchNewsHint,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(),
                  ),
                );
              },
              tooltip: l10n.search,
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: headlinesState.when(
        loading: () {
          return Center(
            child: Semantics(
              label: l10n.loadingNews,
              child: const CircularProgressIndicator(),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    label: l10n.loadingError,
                    child: const Icon(
                      Icons.error_outline,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loadingError,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.checkConnection,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Semantics(
                    button: true,
                    label: l10n.retry,
                    child: FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(topHeadlinesProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        data: (articles) {
          if (articles.isEmpty) {
            return Center(
              child: Text(
                l10n.noNewsAvailable,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(
              topHeadlinesProvider.future,
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: 16);
              },
              itemBuilder: (context, index) {
                final article = articles[index];

                return Semantics(
                  button: true,
                  label: l10n.newsArticle(article.title),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (article.imageUrl.isNotEmpty)
                            Semantics(
                              excludeSemantics: true,
                              child: OptimizedNetworkImage(
                                imageUrl: article.imageUrl,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
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
                                                  .labelMedium
                                                  ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                            ),
                                          const SizedBox(height: 8),
                                          Text(
                                            article.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Seul ce widget écoute favoritesProvider.
                                    _FavoriteButton(
                                      article: article,
                                    ),
                                  ],
                                ),
                                if (article.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    article.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      l10n.readArticle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ],
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
        },
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final isFavorite = ref.watch(
      favoritesProvider.select(
        (favorites) => favorites.any(
          (favorite) => favorite.url == article.url,
        ),
      ),
    );

    return Semantics(
      button: true,
      label: isFavorite
          ? '${l10n.removeFromFavorites} : ${article.title}'
          : '${l10n.addToFavorites} : ${article.title}',
      child: IconButton(
        onPressed: () async {
          await ref
              .read(favoritesProvider.notifier)
              .toggleFavorite(article);

          if (!context.mounted) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isFavorite
                    ? l10n.removedFromFavorites
                    : l10n.addedToFavorites,
              ),
            ),
          );
        },
        tooltip: isFavorite
            ? l10n.removeFromFavorites
            : l10n.addToFavorites,
        icon: Icon(
          isFavorite ? Icons.star : Icons.star_border,
        ),
      ),
    );
  }
}