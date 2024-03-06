import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_favourites/data/github_local_datasource.dart';
import 'package:github_favourites/data/github_remote_datasource.dart';
import 'package:github_favourites/domain/repositories/github_favourites_repository.dart';
import 'package:github_favourites/domain/repositories/user_repository.dart';
import 'package:github_favourites/presentation/app.dart';
import 'package:github_favourites/presentation/bloc/bloc_observer.dart';

typedef AppBuilder = Future<Widget> Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();

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

    GithubRepositoryImpl githubRepository = GithubRepositoryImpl(
      remoteDataSource: githubClient,
      localDataSource: githubLocalDataSource,
    );

    UserRepository userRepository = UserRepository(
      localDataSource: githubLocalDataSource,
    );

    return GitFavouritesApp(
      gitRepository: githubRepository,
      userRepository: userRepository,
    );
  });
}
