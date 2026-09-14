import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../providers/top_headlines_provider.dart';
import 'article_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headlinesState = ref.watch(topHeadlinesProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NewsFlow',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
            tooltip: 'Rechercher',
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: headlinesState.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 56,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Impossible de charger les actualités.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vérifiez votre connexion Internet puis réessayez.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      ref.invalidate(topHeadlinesProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(
              child: Text(
                'Aucune actualité disponible.',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(topHeadlinesProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: 16);
              },
              itemBuilder: (context, index) {
                final article = articles[index];
                final isFavorite = favorites.any(
                  (favorite) => favorite.url == article.url,
                );

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (article.imageUrl.isNotEmpty)
                          Image.network(
                            article.imageUrl,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return const SizedBox(
                                height: 200,
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                                        if (article.sourceName
                                            .isNotEmpty)
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
                                  IconButton(
                                    onPressed: () async {
                                      await ref
                                          .read(
                                            favoritesProvider
                                                .notifier,
                                          )
                                          .toggleFavorite(article);

                                      if (!context.mounted) {
                                        return;
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isFavorite
                                                ? 'Article retiré des favoris.'
                                                : 'Article ajouté aux favoris.',
                                          ),
                                        ),
                                      );
                                    },
                                    tooltip: isFavorite
                                        ? 'Retirer des favoris'
                                        : 'Ajouter aux favoris',
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.star
                                          : Icons.star_border,
                                    ),
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
                                    'Lire l’article',
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}