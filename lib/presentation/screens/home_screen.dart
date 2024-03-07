import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_favourites/config/constants.dart';

import 'package:github_favourites/presentation/bloc/favourites_list_cubit/favourites_list_cubit.dart';
import 'package:github_favourites/presentation/bloc/github_repos_bloc.dart/github_repos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_favourites/presentation/widgets/search_bar_widget.dart';
import 'package:github_favourites/presentation/widgets/list_item_card.dart';
import 'package:github_favourites/presentation/widgets/screen_message.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favouritesCubit = BlocProvider.of<FavouritesListCubit>(context);
    final bloc = BlocProvider.of<GithubReposBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Github repos list"),
        centerTitle: true,
        elevation: 1,
        // can be updated to match with the design file. Looks nicer with tint as for me
        // surfaceTintColor: Theme.of(context).colorScheme.background,
        shadowColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 64.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: Constants.horizontalPadding,
            ),
            child: SizedBox(
              width: 44,
              height: 44,
              child: IconButton(
                icon: const Icon(Icons.star_rate_rounded),
                onPressed: () {
                  favouritesCubit.loadFavourites(bloc.state.user);

                  Navigator.pushNamed(context, '/favourites-repos');
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<GithubReposBloc, GithubReposState>(
        listener: (context, state) {
          if (state.status == SearchScreenStatus.starred ||
              state.status == SearchScreenStatus.unstarred ||
              state.status == SearchScreenStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Constants.horizontalPadding,
            vertical: Constants.verticalPadding,
          ),
          child: HomeView(),
        ),
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SearchBarWidget(
          key: Key('mainGitSearchBar'),
        ),
        BlocBuilder<GithubReposBloc, GithubReposState>(
            builder: (context, state) {
          if (state.status == SearchScreenStatus.loadedSearchResult) {
            return const SearchTextWidget(text: 'What we have found');
          } else if (state.status == SearchScreenStatus.loading) {
            return const SizedBox(height: 16);
          } else {
            return const SearchTextWidget(text: 'Search History');
          }
        }),
        BlocBuilder<GithubReposBloc, GithubReposState>(
          builder: (context, state) {
            /// list of recent searches
            if (state.status == SearchScreenStatus.loadedSearchHistory &&
                state.user.recentSearches.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.user.recentSearches.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(state.user.recentSearches[index]),
                        onTap: () {
                          BlocProvider.of<GithubReposBloc>(context).add(
                            SearchGithubReposByName(
                              state.user.recentSearches[index],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            } else if (state.status == SearchScreenStatus.loading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );

              /// list of search results
            } else if (state.status == SearchScreenStatus.loadedSearchResult) {
              return Expanded(
                child: Scrollbar(
                  trackVisibility: true,
                  thickness: 4,
                  radius: const Radius.circular(2),
                  child: ListView.builder(
                    itemCount: state.searchResults.length,
                    itemBuilder: (context, index) {
                      final repo = state.searchResults[index];
                      return ListItemCard(repo: repo);
                    },
                  ),
                ),
              );
            } else if (state.status == SearchScreenStatus.error) {
              return ScreenMessage(message: state.message);
            }
            return ScreenMessage(message: state.message);
          },
        ),
      ],
    );
  }
}

class SearchTextWidget extends StatelessWidget {
  const SearchTextWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        text,
        style: theme.textTheme.titleMedium!
            .copyWith(color: theme.colorScheme.primary),
        textAlign: TextAlign.start,
      ),
    );
  }
}
