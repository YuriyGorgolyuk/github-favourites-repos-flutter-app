import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_favourites/data/github_local_datasource.dart';
import 'package:github_favourites/data/github_remote_datasource.dart';
import 'package:github_favourites/domain/repositories/github_favourites_repository.dart';
import 'package:github_favourites/domain/repositories/user_repository.dart';
import 'package:github_favourites/presentation/app.dart';
import 'package:github_favourites/presentation/bloc/bloc_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AppBuilder = Future<Widget> Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "dot.env");

  Bloc.observer = SimpleBlocObserver();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(await builder());
}

void main() {
  bootstrap(() async {
    GithubLocalDataSource githubLocalDataSource = GithubLocalDataSource();
    GithubRemoteDataSource githubClient = GithubClient();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    GithubRepositoryImpl githubRepository = GithubRepositoryImpl(
      remoteDataSource: githubClient,
      localDataSource: githubLocalDataSource,
    );

    UserRepository userRepository = UserRepository(
      localDataSource: githubLocalDataSource,
      sharedPreferences: prefs,
    );

    return GitFavouritesApp(
      gitRepository: githubRepository,
      userRepository: userRepository,
    );
  });
}
