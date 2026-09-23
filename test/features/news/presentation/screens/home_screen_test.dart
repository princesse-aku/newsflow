import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsflow/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:newsflow/features/news/domain/entities/article.dart';
import 'package:newsflow/features/news/domain/repositories/news_repository.dart';
import 'package:newsflow/features/news/presentation/providers/news_providers.dart';
import 'package:newsflow/features/news/presentation/screens/home_screen.dart';
import 'package:newsflow/l10n/app_localizations.dart';

class FakeNewsRepository implements NewsRepository {
  FakeNewsRepository({this.articles = const [], this.error});

  final List<Article> articles;
  final Object? error;

  @override
  Future<List<Article>> getTopHeadlines() async {
    if (error != null) {
      throw error!;
    }

    return articles;
  }

  @override
  Future<List<Article>> searchNews(String query) async {
    if (error != null) {
      throw error!;
    }

    return articles;
  }
}

class FakeFavoritesNotifier extends FavoritesNotifier {
  @override
  List<Article> build() {
    return [];
  }
}

void main() {
  const article = Article(
    title: 'Flutter et Firebase',
    description: 'Une actualité sur Flutter et Firebase.',
    url: 'https://example.com/article',
    imageUrl: '',
    sourceName: 'Tech News',
    publishedAt: null,
    author: 'Auteur',
    content: 'Contenu de test.',
  );

  Widget createWidget({FakeNewsRepository? repository}) {
    return ProviderScope(
      overrides: [
        newsRepositoryProvider.overrideWithValue(
          repository ?? FakeNewsRepository(),
        ),
        favoritesProvider.overrideWith(FakeFavoritesNotifier.new),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('affiche un indicateur de chargement', (tester) async {
      final repository = FakeNewsRepository(articles: const [article]);

      await tester.pumpWidget(createWidget(repository: repository));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('affiche une actualité lorsque les données sont disponibles', (
      tester,
    ) async {
      final repository = FakeNewsRepository(articles: const [article]);

      await tester.pumpWidget(createWidget(repository: repository));

      await tester.pumpAndSettle();

      expect(find.text('Flutter et Firebase'), findsOneWidget);

      expect(
        find.text('Une actualité sur Flutter et Firebase.'),
        findsOneWidget,
      );

      expect(find.text('Tech News'), findsOneWidget);

      expect(find.text('Lire l’article'), findsOneWidget);
    });

    testWidgets(
      'affiche un message lorsque aucune actualité n est disponible',
      (tester) async {
        final repository = FakeNewsRepository(articles: const []);

        await tester.pumpWidget(createWidget(repository: repository));

        await tester.pumpAndSettle();

        expect(find.text('Aucune actualité disponible.'), findsOneWidget);
      },
    );

    testWidgets('affiche le message d erreur lorsque le chargement échoue', (
      tester,
    ) async {
      final repository = FakeNewsRepository(error: Exception('Erreur réseau'));

      await tester.pumpWidget(createWidget(repository: repository));

      await tester.pumpAndSettle();

      expect(
        find.text('Impossible de charger les actualités.'),
        findsOneWidget,
      );

      expect(
        find.text('Vérifiez votre connexion Internet puis réessayez.'),
        findsOneWidget,
      );

      expect(find.widgetWithText(FilledButton, 'Réessayer'), findsOneWidget);
    });
  });
}
