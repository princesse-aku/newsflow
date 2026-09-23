import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';

import 'package:newsflow/features/news/domain/entities/article.dart';
import 'package:newsflow/features/news/domain/repositories/news_repository.dart';
import 'package:newsflow/features/news/presentation/providers/news_providers.dart';
import 'package:newsflow/features/news/presentation/screens/main_screen.dart';
import 'package:newsflow/features/news/presentation/screens/search_screen.dart';
import 'package:newsflow/firebase_options.dart';

class FakeNewsRepository implements NewsRepository {
  const FakeNewsRepository();

  static const Article testArticle = Article(
    title: 'Flutter et Firebase',
    description: 'Une actualité de test sur Flutter et Firebase.',
    url: 'https://example.com/flutter-firebase',
    imageUrl: '',
    sourceName: 'Tech News',
    publishedAt: null,
    author: 'Auteur',
    content: 'Contenu de test.',
  );

  @override
  Future<List<Article>> getTopHeadlines() async {
    return const [testArticle];
  }

  @override
  Future<List<Article>> searchNews(String query) async {
    return const [testArticle];
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Hive.initFlutter();

    if (!Hive.isBoxOpen('news_cache')) {
      await Hive.openBox<dynamic>('news_cache');
    }
  });

  Widget createApp() {
    return ProviderScope(
      overrides: [
        newsRepositoryProvider.overrideWithValue(const FakeNewsRepository()),
      ],
      child: const MaterialApp(home: MainScreen()),
    );
  }

  group('Navigation de NewsFlow', () {
    testWidgets(
      'l utilisateur peut naviguer entre Accueil, Favoris et Profil',
      (tester) async {
        await tester.pumpWidget(createApp());

        await tester.pumpAndSettle();

        expect(find.text('NewsFlow'), findsOneWidget);
        expect(find.text('Accueil'), findsOneWidget);

        await tester.tap(find.text('Favoris'));
        await tester.pumpAndSettle();

        expect(find.text('Favoris'), findsWidgets);

        await tester.tap(find.text('Profil'));
        await tester.pumpAndSettle();

        expect(find.text('Profil'), findsWidgets);

        await tester.tap(find.text('Accueil'));
        await tester.pumpAndSettle();

        expect(find.text('NewsFlow'), findsOneWidget);
      },
    );
  });

  group('Recherche de NewsFlow', () {
    testWidgets(
      'l utilisateur peut rechercher une actualité et ouvrir son détail',
      (tester) async {
        await tester.pumpWidget(createApp());

        await tester.pumpAndSettle();

        // Ouvre l'écran de recherche depuis l'accueil.
        final searchButton = find.byTooltip('Rechercher');

        expect(searchButton, findsOneWidget);

        await tester.tap(searchButton);
        await tester.pumpAndSettle();

        expect(find.byType(SearchScreen), findsOneWidget);
        expect(find.text('Rechercher'), findsOneWidget);
        expect(
          find.text('Saisissez un mot-clé pour rechercher.'),
          findsOneWidget,
        );

        // Saisit une recherche.
        final searchField = find.byType(TextField);

        expect(searchField, findsOneWidget);

        await tester.enterText(searchField, 'Flutter');

        await tester.testTextInput.receiveAction(TextInputAction.search);

        await tester.pumpAndSettle();

        // Le faux repository retourne notre article de test.
        expect(find.text('Flutter et Firebase'), findsOneWidget);

        expect(find.text('Tech News'), findsOneWidget);

        // Ouvre le détail de l'article.
        await tester.tap(find.text('Flutter et Firebase'));

        await tester.pumpAndSettle();

        expect(find.text('Flutter et Firebase'), findsOneWidget);

        expect(find.text('Tech News'), findsOneWidget);
      },
    );
  });
}
