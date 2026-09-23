import 'package:flutter/material.dart';

import '../../../../core/widgets/optimized_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.readArticle)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              Semantics(
                excludeSemantics: true,
                child: OptimizedNetworkImage(
                  imageUrl: article.imageUrl,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.sourceName.isNotEmpty)
                    Text(
                      article.sourceName,
                      style: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (article.publishedAt != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 16),
                        const SizedBox(width: 8),
                        Text(_formatDate(article.publishedAt!)),
                      ],
                    ),
                  ],
                  if (article.author.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(article.author)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (article.description.isNotEmpty) ...[
                    Text(
                      article.description,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (article.content.isNotEmpty)
                    Text(
                      article.content,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  if (article.url.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Semantics(
                      button: true,
                      label: l10n.openSource,
                      hint: l10n.openSourceHint,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showSourceMessage(context, l10n);
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: Text(l10n.openSource),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  void _showSourceMessage(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.sourceOpeningSoon)));
  }
}
