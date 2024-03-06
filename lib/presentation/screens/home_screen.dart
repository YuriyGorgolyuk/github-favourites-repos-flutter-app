import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_favourites/presentation/bloc/favourites_list_cubit/favourites_list_cubit.dart';
import 'package:github_favourites/presentation/bloc/github_repos_bloc.dart/github_repos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_favourites/presentation/widgets/screen_message.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favouritesCubit = BlocProvider.of<FavouritesListCubit>(context);
    final bloc = BlocProvider.of<GithubReposBloc>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.add(const SearchGithubReposByName('test'));
        },
        child: const Icon(Icons.refresh_rounded),
      ),
      appBar: AppBar(
        title: const Text("Github repos list"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_rate_rounded),
            onPressed: () {
              favouritesCubit.loadFavourites(bloc.state.user);
              print(bloc.state.user);
              Navigator.pushNamed(context, '/favourites-repos');
            },
          ),
        ],
      ),
      body: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GithubReposBloc, GithubReposState>(
      builder: (context, state) {
        if (state.status == SearchScreenStatus.loadedSearchHistory) {
          return ScreenMessage(
            message: state.message,
          );
        }
        return ScreenMessage(message: state.message);
      },
    );
  }
}
