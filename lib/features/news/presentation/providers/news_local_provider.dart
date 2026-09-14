import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/datasources/news_local_data_source.dart';

final newsCacheBoxProvider = Provider<Box<dynamic>>((ref) {
  return Hive.box<dynamic>('news_cache');
});

final newsLocalDataSourceProvider =
    Provider<NewsLocalDataSource>((ref) {
  final box = ref.watch(newsCacheBoxProvider);

  return NewsLocalDataSource(
    box: box,
  );
});