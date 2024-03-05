import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_favourites/app.dart';

typedef AppBuilder = Future<Widget> Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(await builder());
}

void main() {
  bootstrap(() async {
    return const GitFavouritesApp();
  });
}
