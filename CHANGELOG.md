# Changelog

Toutes les modifications importantes de NewsFlow sont documentées dans ce fichier.

Le format est inspiré de [Keep a Changelog](https://keepachangelog.com/fr-FR/1.1.0/).

---

## [1.2.0] - 2026-09-23

### Ajouté

- Internationalisation en français et en anglais.
- Support de l'accessibilité avec `Semantics`.
- Tests widget supplémentaires.
- Tests d'intégration.
- Workflow GitHub Actions pour l'intégration continue.
- Documentation complète du projet.

### Amélioré

- Optimisation du chargement des images avec `CachedNetworkImage`.
- Optimisation de la mémoire utilisée par les images.
- Réduction des rebuilds inutiles avec Riverpod.
- Optimisation de `HomeScreen`, `SearchScreen` et `FavoritesScreen`.
- Amélioration de la structure des écrans avec des widgets spécialisés.
- Conservation de l'état des écrans avec `IndexedStack`.

### Tests

- Vérification avec `flutter analyze`.
- Exécution des tests unitaires.
- Exécution des tests widget.
- Exécution des tests d'intégration.

---

## [1.1.0] - 2026-09-15

### Ajouté

- Écran de recherche d'actualités.
- Écran de détail d'un article.
- Gestion des articles favoris.
- Cache local avec Hive.
- Fonctionnement avec les données en cache lorsque l'API est indisponible.
- Écran de profil utilisateur.
- Gestion des erreurs réseau.

### Amélioré

- Architecture Feature-First.
- Gestion d'état avec Riverpod.
- Communication réseau centralisée avec Dio.
- Séparation entre DataSource, Repository et présentation.

### Tests

- Tests des modèles d'articles.
- Tests du cache.
- Tests du Repository.
- Test du démarrage de l'application.

---

## [1.0.0] - 2026-09-07

### Ajouté

- Première version de NewsFlow.
- Authentification avec Firebase Authentication.
- Inscription avec email et mot de passe.
- Connexion et déconnexion.
- Consultation des actualités avec NewsAPI.
- Architecture Flutter Feature-First.
- Configuration Firebase avec FlutterFire.
- Client réseau basé sur Dio.
- Gestion des actualités avec Repository Pattern.
- Première suite de tests automatisés.

### Technique

- Flutter
- Dart
- Firebase Authentication
- NewsAPI
- Dio
- Riverpod
- Hive
- Mocktail
- Git / GitHub