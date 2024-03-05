import 'package:flutter/material.dart';

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
      home: Center(
        child: Text("Your favourites Git repos"),
      ),
    );
  }
}
