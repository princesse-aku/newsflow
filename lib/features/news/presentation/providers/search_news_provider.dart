import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/article.dart';
import 'news_providers.dart';

final searchNewsProvider = FutureProvider.family<List<Article>, String>((
  ref,
  query,
) async {
  final repository = ref.watch(newsRepositoryProvider);

  return repository.searchNews(query);
});
