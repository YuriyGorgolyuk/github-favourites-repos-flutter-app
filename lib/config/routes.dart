import 'package:flutter/material.dart';
import 'package:github_favourites/presentation/screens/favourites_screen.dart';
import 'package:github_favourites/presentation/screens/home_screen.dart';
import 'package:github_favourites/presentation/screens/loading_screen.dart';

class AppRoutes {
  /// This is the default route that reserved for sign in page
  /// Commented because doesn't need for the test task
  // static const String signIn = '/';
  static const String home = '/';
  static const String loading = '/loading';
  static const String favouritesRepos = '/favourites-repos';

  static Map<String, WidgetBuilder> get routes => {
        loading: (context) => const LoadingScreen(),
        home: (context) => const HomeScreen(),
        favouritesRepos: (context) => const FavouritesScreen(),
      };
}
