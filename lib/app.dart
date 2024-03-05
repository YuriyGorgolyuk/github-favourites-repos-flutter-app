import 'package:flutter/material.dart';
import 'package:github_favourites/config/git_favouries_theme.dart';

class GitFavouritesApp extends StatelessWidget {
  const GitFavouritesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GitFavouritesAppView();
  }
}

class GitFavouritesAppView extends StatelessWidget {
  const GitFavouritesAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: GitFavouritesTheme().light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Git Favourites"),
        ),
        body: Center(
          child: Text("Your favourites Git repos"),
        ),
      ),
    );
  }
}
