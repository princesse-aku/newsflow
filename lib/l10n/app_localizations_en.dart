// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NewsFlow';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search';

  @override
  String get searchNews => 'Search for news';

  @override
  String get searchHint => 'E.g. technology, sports, AI...';

  @override
  String get retry => 'Retry';

  @override
  String get readArticle => 'Read article';

  @override
  String get noNewsAvailable => 'No news available.';

  @override
  String get noNewsFound => 'No news found.';

  @override
  String get enterKeyword => 'Enter a keyword to search.';

  @override
  String get loadingNews => 'Loading news';

  @override
  String get loadingError => 'Unable to load the news.';

  @override
  String get checkConnection => 'Check your Internet connection and try again.';

  @override
  String get searchError => 'Unable to perform the search.';

  @override
  String get addedToFavorites => 'Article added to favorites.';

  @override
  String get removedFromFavorites => 'Article removed from favorites.';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get mainNavigation => 'Main navigation';

  @override
  String get searchNewsHint => 'Opens the search screen';

  @override
  String get readArticleHint => 'Tap to read the article';

  @override
  String get noUserConnected => 'No user connected.';

  @override
  String get myAccount => 'My account';

  @override
  String get emailNotAvailable => 'Email not available';

  @override
  String get emailAddress => 'Email address';

  @override
  String get notAvailable => 'Not available';

  @override
  String get status => 'Status';

  @override
  String get accountConnected => 'Account connected';

  @override
  String get logout => 'Log out';

  @override
  String get welcomeToNewsFlow => 'Welcome to NewsFlow';

  @override
  String get loginToContinue => 'Log in to continue';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get password => 'Password';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get passwordTooShort => 'Password must contain at least 6 characters';

  @override
  String get login => 'Log in';

  @override
  String get createAccount => 'Create an account';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get loading => 'Loading';

  @override
  String get invalidCredentials => 'Incorrect email or password.';

  @override
  String get invalidEmail => 'Please enter a valid email address.';

  @override
  String get userDisabled => 'This account has been disabled.';

  @override
  String get tooManyRequests => 'Too many attempts. Please try again later.';

  @override
  String get networkError => 'Network error. Check your Internet connection.';

  @override
  String get genericAuthError => 'An error occurred. Please try again.';

  @override
  String get joinNewsFlow => 'Join NewsFlow';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get createMyAccount => 'Create my account';

  @override
  String get alreadyHaveAccount => 'I already have an account';

  @override
  String get emailAlreadyInUse => 'This email address is already in use.';

  @override
  String get weakPassword => 'The password is too weak.';

  @override
  String get clearFavorites => 'Delete all favorites';

  @override
  String get noFavorites => 'No favorites';

  @override
  String get addFavoritesToFindThemHere => 'Add articles to your favorites to find them here.';

  @override
  String favoriteArticle(Object title) {
    return 'Favorite article: $title';
  }

  @override
  String removeFavoriteArticle(Object title) {
    return 'Remove $title from favorites';
  }

  @override
  String get clearFavoritesTitle => 'Delete favorites?';

  @override
  String get clearFavoritesMessage => 'All your favorite articles will be deleted.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String newsArticle(Object title) {
    return 'News article: $title';
  }

  @override
  String get openSource => 'Open source';

  @override
  String get openSourceHint => 'Opens the article source';

  @override
  String get sourceOpeningSoon => 'Opening the source will be available soon.';

  @override
  String get checkingAuthentication => 'Checking connection';

  @override
  String get authenticationError => 'Connection error';

  @override
  String get authenticationCheckFailed => 'Unable to verify the connection.';
}
