import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_favourites/config/constants.dart';
import 'package:github_favourites/config/git_favouries_theme.dart';
import 'package:github_favourites/config/routes.dart';
import 'package:github_favourites/domain/repositories/github_favourites_repository.dart';
import 'package:github_favourites/domain/repositories/user_repository.dart';
import 'package:github_favourites/presentation/bloc/favourites_list_cubit/favourites_list_cubit.dart';

import 'package:github_favourites/presentation/bloc/github_repos_bloc.dart/github_repos_bloc.dart';

class GitFavouritesApp extends StatelessWidget {
  const GitFavouritesApp({
    super.key,
    required this.gitRepository,
    required this.userRepository,
  });

  final GithubRepositoryImpl gitRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: gitRepository),
        RepositoryProvider.value(value: userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GithubReposBloc(
              userRepository: userRepository,
              gitRepository: gitRepository,
            ),
          ),
          BlocProvider(
            create: (context) => FavouritesListCubit(
              gitRepository: gitRepository,
            ),
          ),
        ],
        child: const GitFavouritesAppView(),
      ),
    );
  }
}

class GitFavouritesAppView extends StatefulWidget {
  const GitFavouritesAppView({super.key});

  @override
  State<GitFavouritesAppView> createState() => _GitFavouritesAppViewState();
}

class _GitFavouritesAppViewState extends State<GitFavouritesAppView> {
  GithubReposBloc get bloc => BlocProvider.of<GithubReposBloc>(context);

  @override
  void initState() {
    super.initState();
    bloc.add(const LoadGithubRepos());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final _navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: Constants.appName,
      routes: AppRoutes.routes,
      themeMode: ThemeMode.light,
      theme: GitFavouritesTheme.light,
      builder: (context, child) {
        return BlocListener<GithubReposBloc, GithubReposState>(
          listener: (context, state) {
            switch (state.appStatus) {
              case AppStatus.unauthenticated:
                _navigatorKey.currentState!.pushReplacementNamed('/loading');
              case AppStatus.initialisation:
                _navigatorKey.currentState!.pushReplacementNamed('/loading');
              case AppStatus.authenticated:
                _navigatorKey.currentState!.pushReplacementNamed('/');
                break;

              default:
                _navigatorKey.currentState!.pushReplacementNamed('/');
                break;
            }
          },
          child: child,
        );
      },
    );
  }
}
