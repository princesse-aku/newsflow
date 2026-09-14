import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/article.dart';
import 'news_providers.dart';

final topHeadlinesProvider =
    FutureProvider<List<Article>>((ref) async {
  final repository = ref.watch(newsRepositoryProvider);

  return repository.getTopHeadlines();
});