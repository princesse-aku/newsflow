// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'NewsFlow';

  @override
  String get home => 'Accueil';

  @override
  String get favorites => 'Favoris';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Rechercher';

  @override
  String get searchNews => 'Rechercher une actualité';

  @override
  String get searchHint => 'Ex. technologie, sport, IA...';

  @override
  String get retry => 'Réessayer';

  @override
  String get readArticle => 'Lire l’article';

  @override
  String get noNewsAvailable => 'Aucune actualité disponible.';

  @override
  String get noNewsFound => 'Aucune actualité trouvée.';

  @override
  String get enterKeyword => 'Saisissez un mot-clé pour rechercher.';

  @override
  String get loadingNews => 'Chargement des actualités en cours';

  @override
  String get loadingError => 'Impossible de charger les actualités.';

  @override
  String get checkConnection => 'Vérifiez votre connexion Internet puis réessayez.';

  @override
  String get searchError => 'Impossible d’effectuer la recherche.';

  @override
  String get addedToFavorites => 'Article ajouté aux favoris.';

  @override
  String get removedFromFavorites => 'Article retiré des favoris.';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get mainNavigation => 'Navigation principale';

  @override
  String get searchNewsHint => 'Ouvre l’écran de recherche';

  @override
  String get readArticleHint => 'Appuyez pour lire l’article';

  @override
  String get noUserConnected => 'Aucun utilisateur connecté.';

  @override
  String get myAccount => 'Mon compte';

  @override
  String get emailNotAvailable => 'Email non disponible';

  @override
  String get emailAddress => 'Adresse email';

  @override
  String get notAvailable => 'Non disponible';

  @override
  String get status => 'Statut';

  @override
  String get accountConnected => 'Compte connecté';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get welcomeToNewsFlow => 'Bienvenue sur NewsFlow';

  @override
  String get loginToContinue => 'Connectez-vous pour continuer';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'exemple@email.com';

  @override
  String get password => 'Mot de passe';

  @override
  String get enterEmail => 'Veuillez saisir votre email';

  @override
  String get enterValidEmail => 'Veuillez saisir un email valide';

  @override
  String get enterPassword => 'Veuillez saisir votre mot de passe';

  @override
  String get passwordTooShort => 'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get login => 'Se connecter';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get loading => 'Chargement';

  @override
  String get invalidCredentials => 'Email ou mot de passe incorrect.';

  @override
  String get invalidEmail => 'Veuillez saisir une adresse email valide.';

  @override
  String get userDisabled => 'Ce compte a été désactivé.';

  @override
  String get tooManyRequests => 'Trop de tentatives. Réessayez plus tard.';

  @override
  String get networkError => 'Erreur réseau. Vérifiez votre connexion Internet.';

  @override
  String get genericAuthError => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get joinNewsFlow => 'Rejoignez NewsFlow';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get confirmPasswordRequired => 'Veuillez confirmer votre mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get createMyAccount => 'Créer mon compte';

  @override
  String get alreadyHaveAccount => 'J’ai déjà un compte';

  @override
  String get emailAlreadyInUse => 'Cette adresse email est déjà utilisée.';

  @override
  String get weakPassword => 'Le mot de passe est trop faible.';

  @override
  String get clearFavorites => 'Supprimer tous les favoris';

  @override
  String get noFavorites => 'Aucun favori';

  @override
  String get addFavoritesToFindThemHere => 'Ajoutez des articles à vos favoris pour les retrouver ici.';

  @override
  String favoriteArticle(Object title) {
    return 'Article favori : $title';
  }

  @override
  String removeFavoriteArticle(Object title) {
    return 'Retirer $title des favoris';
  }

  @override
  String get clearFavoritesTitle => 'Supprimer les favoris ?';

  @override
  String get clearFavoritesMessage => 'Tous vos articles favoris seront supprimés.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String newsArticle(Object title) {
    return 'Actualité : $title';
  }

  @override
  String get openSource => 'Ouvrir la source';

  @override
  String get openSourceHint => 'Ouvre la source de l’article';

  @override
  String get sourceOpeningSoon => 'L’ouverture de la source sera disponible prochainement.';

  @override
  String get checkingAuthentication => 'Vérification de la connexion en cours';

  @override
  String get authenticationError => 'Erreur de connexion';

  @override
  String get authenticationCheckFailed => 'Impossible de vérifier la connexion.';
}
