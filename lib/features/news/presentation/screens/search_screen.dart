import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/optimized_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../news/domain/entities/article.dart';
import '../providers/search_news_provider.dart';
import 'article_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      return;
    }

    setState(() {
      _query = query;
    });

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                labelText: l10n.searchNews,
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Semantics(
                  button: true,
                  label: l10n.search,
                  child: IconButton(
                    onPressed: _search,
                    tooltip: l10n.search,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _SearchResults(
              query: _query,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({
    required this.query,
  });

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (query.isEmpty) {
      return Center(
        child: Text(
          l10n.enterKeyword,
        ),
      );
    }

    final searchState = ref.watch(
      searchNewsProvider(query),
    );

    return searchState.when(
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
                  label: l10n.searchError,
                  child: const Icon(
                    Icons.error_outline,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.searchError,
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
                      ref.invalidate(
                        searchNewsProvider(query),
                      );
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
              l10n.noNewsFound,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          itemCount: articles.length,
          separatorBuilder: (_, _) {
            return const SizedBox(height: 12);
          },
          itemBuilder: (context, index) {
            final article = articles[index];

            return _SearchArticleCard(
              article: article,
            );
          },
        );
      },
    );
  }
}

class _SearchArticleCard extends StatelessWidget {
  const _SearchArticleCard({
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}