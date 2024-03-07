import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_favourites/config/constants.dart';

import 'package:github_favourites/presentation/bloc/favourites_list_cubit/favourites_list_cubit.dart';
import 'package:github_favourites/presentation/bloc/github_repos_bloc.dart/github_repos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
            child: IconButton(
              icon: const Icon(Icons.star_rate_rounded),
              onPressed: () {
                favouritesCubit.loadFavourites(bloc.state.user);

                Navigator.pushNamed(context, '/favourites-repos');
              },
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
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
      children: [
        const SearchBar(
          key: Key('mainGitSearchBar'),
        ),
        BlocBuilder<GithubReposBloc, GithubReposState>(
            builder: (context, state) {
          if (state.status == SearchScreenStatus.loadedSearchResult) {
            return SearchTextWidget(text: 'What we have found');
          } else if (state.status == SearchScreenStatus.loading) {
            return Text('');
          } else {
            return SearchTextWidget(text: 'Search History');
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
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        text,
        style: theme.textTheme.titleMedium!
            .copyWith(color: theme.colorScheme.primary),
        textAlign: TextAlign.start,
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Timer? debounce;
  TextEditingController controller = TextEditingController();
  var focusNode = FocusNode();
  String hintText = 'Search';
  String helpText = '';

  GithubReposBloc get bloc => BlocProvider.of<GithubReposBloc>(context);
  ThemeData get theme => Theme.of(context);

  void onSearch() {
    if (debounce?.isActive ?? false) debounce?.cancel();

    if (controller.text.isNotEmpty && controller.text.length > 2) {
      bloc.add(SearchGithubReposByName(controller.text));
    } else if (controller.text.isEmpty) {
      setState(() {
        helpText = '';
      });
    } else {
      setState(() {
        helpText = 'Please enter at least 3 characters';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.text = bloc.state.query;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          errorText: helpText,
          prefix: Padding(
            padding: const EdgeInsets.only(right: 10, top: 12),
            child: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(SvgIcon.search),
            ),
          ),
          fillColor: focusNode.hasFocus
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.background,
          suffix: controller.text.isNotEmpty
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 40,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        theme.colorScheme.secondaryContainer,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (debounce?.isActive ?? false) debounce?.cancel();
                      setState(() => controller.clear());
                      bloc.add(const ClearSearchField());
                    },
                    icon: SvgPicture.asset(
                      SvgIcon.close,
                    ),
                  ),
                )
              : null,
        ),
        onTap: () => setState(() => focusNode.requestFocus()),
        onChanged: (value) {
          setState(() {
            controller.text = value;
          });
          if (debounce?.isActive ?? false) debounce?.cancel();
          debounce = Timer(
            const Duration(milliseconds: 4000),
            () => onSearch(),
          );
        },
        onTapOutside: (event) {
          setState(() {
            focusNode.unfocus();
          });
        },
        onSubmitted: (value) => onSearch(),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
