import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/news_remote_data_source.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_local_provider.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final newsRemoteDataSourceProvider = Provider<NewsRemoteDataSource>((ref) {
  return NewsRemoteDataSource(
    dioClient: ref.watch(dioClientProvider),
  );
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    ref.watch(newsRemoteDataSourceProvider),
    ref.watch(newsLocalDataSourceProvider),
  );
});
