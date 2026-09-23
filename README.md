# NewsFlow

NewsFlow est une application mobile Flutter permettant de consulter, rechercher et sauvegarder des actualités provenant d'une API REST.

L'application utilise Firebase Authentication pour la gestion des utilisateurs, NewsAPI pour les actualités et Hive pour la persistance locale et le fonctionnement hors ligne.

Le projet a été conçu avec une approche **production-ready**, incluant tests automatisés, optimisation des performances, accessibilité, internationalisation et intégration continue avec GitHub Actions.

---

## Fonctionnalités

- Inscription avec email et mot de passe
- Connexion avec Firebase Authentication
- Déconnexion
- Consultation des actualités
- Recherche d'actualités
- Consultation du détail d'un article
- Ajout et suppression d'articles favoris
- Suppression de tous les favoris
- Mise en cache locale avec Hive
- Fonctionnement avec les données en cache lorsque l'API est indisponible
- Gestion des erreurs réseau
- Actualisation des actualités
- Écran de profil utilisateur
- Interface en français et en anglais
- Images réseau mises en cache et optimisées
- Support de l'accessibilité avec `Semantics`
- Tests unitaires, widget et d'intégration
- Analyse statique avec `flutter analyze`
- Vérification automatique avec GitHub Actions

---

## Technologies utilisées

| Technologie | Utilisation |
|---|---|
| Flutter | Framework mobile |
| Dart | Langage de programmation |
| Firebase Authentication | Authentification |
| NewsAPI | API REST d'actualités |
| Dio | Requêtes HTTP |
| Hive | Stockage et cache local |
| Riverpod | Gestion d'état |
| CachedNetworkImage | Cache et optimisation des images |
| Flutter Localizations | Internationalisation FR/EN |
| Mocktail | Tests et mocks |
| Git / GitHub | Versionnement et livraison |
| GitHub Actions | Intégration continue |

---

## Architecture

Le projet utilise une architecture **Feature-First** inspirée de la Clean Architecture.

```text
lib/
├── core/
│   ├── config/
│   ├── network/
│   └── widgets/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── news/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── favorites/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/
│       └── presentation/
│
├── l10n/
│
└── main.dart

---

## Flux de données

```text
UI
 ↓
Riverpod Provider
 ↓
Repository
 ↓
Data Source
 ↓
Dio / Hive

---

## Flux des actualités

```text
NewsAPI
   ↓
Dio
   ↓
RemoteDataSource
   ↓
NewsRepository
   ↓
Hive
   ↓
UI

---

## Fonctionnement hors ligne

En cas d'indisponibilité de l'API :

```text
API indisponible
       ↓
NewsRepository
       ↓
Hive
       ↓
Données précédemment mises en cache
       ↓
UI

---

## Gestion de l'état

Riverpod est utilisé pour gérer l'état de l'application.

Les Providers permettent notamment de gérer :

les actualités principales ;
les recherches ;
les favoris ;
l'état d'authentification.

L'utilisation de Providers permet de limiter les rebuilds inutiles et de séparer la logique métier de l'interface utilisateur.

Authentification

Firebase Authentication est utilisé pour gérer :

- l'inscription ;
- la connexion ;
- la déconnexion ;
- l'état de connexion de l'utilisateur.

L'application utilise AuthGate pour déterminer automatiquement si elle doit afficher :

```text
Utilisateur non connecté
        ↓
LoginScreen

Utilisateur connecté
        ↓
MainScreen

---

## API REST

Les actualités sont récupérées avec NewsAPI.

Deux endpoints principaux sont utilisés :

```text
GET /v2/top-headlines
GET /v2/everything

L'accès à l'API nécessite une clé API.

La clé n'est pas enregistrée directement dans le code source.

Elle est fournie au lancement avec --dart-define.

Exemple :

flutter run --dart-define=NEWS_API_KEY=VOTRE_CLE_API

La configuration utilise :

String.fromEnvironment('NEWS_API_KEY')

---

## Réseau avec Dio

Les requêtes réseau passent par un client Dio centralisé.

L'application dispose d'une configuration réseau permettant de centraliser la communication avec les services externes.

Le Repository Pattern permet de séparer :

- la récupération des données ;
- la logique métier ;
- la persistance locale ;
- l'interface utilisateur.

---

## Cache local et mode hors ligne

Hive est utilisé pour stocker localement :

- les actualités récupérées ;
- les articles favoris.

Lorsqu'une requête REST réussit, les données sont sauvegardées dans le cache.

Si une erreur réseau survient, le Repository récupère les dernières données disponibles localement.

Cela permet à l'application de continuer à afficher les données précédemment récupérées lorsque l'API est temporairement indisponible.

---

## Optimisation des images

Les images des articles utilisent --CachedNetworkImage.

Un widget commun :

```text
OptimizedNetworkImage

centralise leur affichage.

Les optimisations comprennent notamment :

- mise en cache des images ;
- chargement différé par le système de liste Flutter ;
- limitation de la taille mémoire des images ;
- placeholder pendant le chargement ;
- image de remplacement en cas d'erreur ;
- adaptation de la résolution à la taille d'affichage.

L'objectif est de limiter la consommation mémoire et les traitements inutiles lors du défilement des listes.

---

## Performance

Plusieurs optimisations ont été appliquées :

- utilisation de widgets --const lorsque possible ;
- --IndexedStack pour conserver l'état des écrans principaux ;
- séparation des widgets responsables de l'écoute des Providers ;
- utilisation de --select pour limiter certains rebuilds ;
- cache des images réseau ;
- limitation de la résolution mémoire des images ;
- listes utilisant --ListView.separated ;
- séparation de l'UI en widgets ciblés.

Ces choix permettent de réduire les rebuilds inutiles et d'améliorer la fluidité de l'application.

---

## Accessibilité

L'application utilise --Semantics pour améliorer son utilisation avec les technologies d'assistance.

Des labels et hints sont notamment disponibles pour :

- les boutons ;
- la navigation principale ;
- les articles ;
- les actions sur les favoris ;
- la recherche ;
- les états de chargement ;
- les messages d'erreur.

Exemple :

```text
Semantics(
  button: true,
  label: l10n.newsArticle(article.title),
  hint: l10n.readArticleHint,
  child: ...
)

---

## Internationalisation

NewsFlow prend en charge deux langues :

- 🇫🇷 Français
- 🇬🇧 Anglais

Les textes de l'interface sont gérés avec Flutter Localizations et les fichiers ARB.

```text
l10n/
├── app_fr.arb
└── app_en.arb

Les textes sont générés automatiquement avec :

```text
flutter gen-l10n

---

## Écrans

L'application contient notamment :

- Connexion
- Inscription
- Accueil / Actualités
- Recherche
- Détail d'un article
- Favoris
- Profil

La navigation principale est organisée autour de :

```text
Accueil
Favoris
Profil

---

## Tests

Le projet possède plusieurs niveaux de tests.

# Tests unitaires

Les tests couvrent notamment :

- les modèles d'articles ;
- les modèles utilisés pour le cache ;
- le Repository des actualités ;
- la récupération depuis l'API ;
- la sauvegarde dans le cache ;
- le fallback vers le cache lorsque l'API est indisponible ;
- la recherche d'actualités.

#Tests widget

Les tests widget vérifient notamment :

- le démarrage de l'application ;
- les écrans principaux ;
- certains comportements de l'interface utilisateur.

# Tests d'intégration

Les tests d'intégration vérifient les parcours principaux de l'application.

Exemple :

```text
flutter test integration_test/app_test.dart -d emulator-5554

Exécuter tous les tests

```text
flutter test

Vérifier l'analyse statique

```text
flutter analyze

---

## Intégration continue

Le projet utilise GitHub Actions pour automatiser les vérifications.

# Workflow :

```text
Push / Pull Request
        ↓
Checkout
        ↓
Installation Flutter
        ↓
flutter pub get
        ↓
dart format
        ↓
flutter analyze
        ↓
flutter test

Le workflow est situé dans :

```text
.github/
└── workflows/
    └── flutter_ci.yml


L'objectif est de détecter automatiquement les problèmes de formatage, d'analyse ou de tests avant la livraison.

---

# Installation

1. Cloner le projet
```text
git clone https://github.com/princesse-aku/newsflow.git
cd newsflow

2. Installer les dépendances

```text
flutter pub get

3. Configurer Firebase

Le projet utilise Firebase Authentication.

La configuration Firebase est générée avec FlutterFire CLI.

```text
flutterfire configure

Le fichier --firebase_options.dart est généré automatiquement par FlutterFire.

4. Configurer NewsAPI

Créer une clé API NewsAPI puis lancer l'application avec :

```text
flutter run --dart-define=NEWS_API_KEY=VOTRE_CLE_API

5. Générer les traductions

```text
flutter gen-l10n

6. Lancer l'application

```text
flutter run --dart-define=NEWS_API_KEY=VOTRE_CLE_API

---

# Vérifications avant livraison

Avant de pousser une modification, exécuter :

```text
dart format .

```text
flutter analyze

```text
flutter test

Puis les tests d'intégration :

```text
flutter test integration_test/app_test.dart -d emulator-5554

---

# Sécurité

Les informations sensibles ne doivent pas être écrites directement dans le code source.

La clé NewsAPI est fournie au moment du lancement :

--dart-define=NEWS_API_KEY=...

Les fichiers contenant des secrets personnels ou des clés privées ne doivent pas être ajoutés au repository.

Les fichiers Firebase nécessaires au fonctionnement de l'application peuvent être conservés conformément à la configuration FlutterFire du projet.

--- 

# Organisation du projet

--auth

Gestion de l'authentification Firebase.

--news

Gestion des actualités :

- modèles ;
- entités ;
- sources de données ;
- Repository ;
- Providers ;
- écrans.

--favorites

Gestion des articles favoris avec Hive.

--profile

Affichage des informations du compte et déconnexion.

--core

Configuration générale, réseau et widgets réutilisables.

---

#Objectifs du projet

Ce projet permet de mettre en pratique :

- Flutter ;
- Dart ;
- Firebase ;
- API REST ;
- Dio ;
- Riverpod ;
- Repository Pattern ;
- architecture Feature-First ;
- persistance locale ;
- fonctionnement hors ligne ;
- gestion des erreurs réseau ;
- cache d'images ;
- optimisation des performances ;
- accessibilité ;
- internationalisation ;
- tests unitaires ;
- tests widget ;
- tests d'intégration ;
- GitHub Actions ;
- préparation d'une application pour une livraison production-ready.

---

# Licence

Ce projet est réalisé dans le cadre d'un projet d'apprentissage et de mise en pratique du développement Flutter.
