# NewsFlow 

NewsFlow est une application mobile Flutter permettant de consulter, rechercher et sauvegarder des actualités provenant d'une API REST.

L'application utilise Firebase Authentication pour la gestion des utilisateurs, NewsAPI pour les actualités et Hive pour la persistance locale et le fonctionnement hors ligne.

##  Fonctionnalités

*  Inscription avec email et mot de passe
*  Connexion avec Firebase Authentication
*  Déconnexion
*  Consultation des actualités
*  Recherche d'actualités
*  Consultation du détail d'un article
*  Ajout et suppression d'articles favoris
*  Mise en cache locale avec Hive
*  Fonctionnement avec les données en cache lorsque l'API est indisponible
*  Gestion des erreurs réseau
*  Actualisation des actualités
*  Écran de profil utilisateur

##  Technologies utilisées

| Technologie             | Utilisation                |
| ----------------------- | -------------------------- |
| Flutter                 | Framework mobile           |
| Dart                    | Langage de programmation   |
| Firebase Authentication | Authentification           |
| NewsAPI                 | API REST d'actualités      |
| Dio                     | Requêtes HTTP              |
| Hive                    | Stockage et cache local    |
| Riverpod                | Gestion d'état             |
| Mocktail                | Tests unitaires            |
| Git / GitHub            | Versionnement et livraison |

##  Architecture

Le projet utilise une architecture **Feature-First** inspirée de la Clean Architecture.

```text
lib/
├── core/
│   ├── config/
│   └── network/
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
└── main.dart
```

### Flux de données

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
```

Pour les actualités :

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
```

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
```

##  Authentification

Firebase Authentication est utilisé pour gérer :

* l'inscription ;
* la connexion ;
* la déconnexion ;
* l'état de connexion de l'utilisateur.

L'application utilise `AuthGate` pour déterminer automatiquement si elle doit afficher l'écran de connexion ou l'application principale.

##  API REST

Les actualités sont récupérées avec **NewsAPI**.

Deux endpoints principaux sont utilisés :

```text
GET /v2/top-headlines
GET /v2/everything
```

L'accès à l'API nécessite une clé API.

La clé n'est pas enregistrée directement dans le code source.

Elle est fournie au lancement avec `--dart-define`.

Exemple :

```powershell
flutter run --dart-define=NEWS_API_KEY=VOTRE_CLE_API
```

La configuration est récupérée avec :

```dart
String.fromEnvironment('NEWS_API_KEY')
```

##  Intercepteur Dio

Les requêtes réseau passent par un client Dio centralisé.

Un intercepteur ajoute automatiquement le token Firebase de l'utilisateur lorsqu'il est disponible :

```text
Application
    ↓
DioClient
    ↓
Interceptor
    ↓
Firebase ID Token
    ↓
API
```

Firebase Authentication gère automatiquement le renouvellement de ses tokens.

##  Cache local et mode hors ligne

Hive est utilisé pour stocker localement :

* les actualités récupérées ;
* les articles favoris.

Lorsqu'une requête REST réussit, les données sont sauvegardées dans le cache.

Si une erreur réseau survient, le Repository récupère les dernières données disponibles localement.

Cela permet à l'application de continuer à afficher des données même lorsque la connexion Internet est indisponible.

##  Tests

Le projet contient actuellement **4 tests automatisés** :

### Test widget

Vérification du démarrage de l'application.

### Tests du Repository

1. Récupération des actualités depuis l'API et sauvegarde dans le cache.
2. Récupération des actualités depuis le cache lorsque l'API est indisponible.
3. Recherche d'actualités et sauvegarde des résultats dans le cache.

Les tests utilisent :

```text
flutter_test
mocktail
```

Pour exécuter tous les tests :

```powershell
flutter test
```

Résultat attendu :

```text
All tests passed!
```

##  Installation

### 1. Cloner le projet

```powershell
git clone https://github.com/princesse-aku/newsflow.git
cd newsflow
```

### 2. Installer les dépendances

```powershell
flutter pub get
```

### 3. Configurer Firebase

Le projet utilise Firebase Authentication.

Le fichier `firebase_options.dart` est généré avec FlutterFire CLI.

### 4. Configurer NewsAPI

Créer une clé API NewsAPI puis lancer l'application avec :

```powershell
flutter run --dart-define=NEWS_API_KEY=VOTRE_CLE_API
```

### 5. Lancer les tests

```powershell
flutter test
```

### 6. Vérifier le code

```powershell
flutter analyze
```

##  Écrans de l'application

NewsFlow contient notamment :

1. **Connexion**
2. **Inscription**
3. **Accueil / Actualités**
4. **Recherche**
5. **Détail d'un article**
6. **Favoris**
7. **Profil**

##  Organisation du projet

### `auth`

Gestion de l'authentification Firebase.

### `news`

Gestion des actualités :

* modèles ;
* entités ;
* sources de données ;
* Repository ;
* Providers ;
* écrans.

### `favorites`

Gestion des articles favoris avec Hive.

### `profile`

Affichage des informations du compte et déconnexion.

### `core`

Configuration générale et gestion du réseau.

##  Sécurité

Les informations sensibles ne doivent pas être écrites directement dans le code source.

La clé NewsAPI est fournie au moment du lancement :

```text
--dart-define
```

Les fichiers de configuration Firebase générés sont nécessaires au fonctionnement de l'application.

##  Objectifs du projet

Ce projet permet de mettre en pratique :

* Flutter ;
* Firebase ;
* API REST ;
* Dio ;
* gestion d'état avec Riverpod ;
* Repository Pattern ;
* architecture Feature-First ;
* persistance locale ;
* fonctionnement hors ligne ;
* gestion des erreurs réseau ;
* tests unitaires ;
* préparation d'une application pour une livraison GitHub.

