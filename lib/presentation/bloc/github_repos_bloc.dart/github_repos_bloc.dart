import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_favourites/domain/entities/repository_entity.dart';
import 'package:github_favourites/domain/entities/user_entity.dart';
import 'package:github_favourites/domain/repositories/github_favourites_repository.dart';
import 'package:github_favourites/domain/repositories/user_repository.dart';

part 'github_repos_event.dart';
part 'github_repos_state.dart';

class GithubReposBloc extends Bloc<GithubReposEvent, GithubReposState> {
  GithubReposBloc({
    required UserRepository userRepository,
    required GithubRepositoryImpl gitRepository,
  })  : _userRepository = userRepository,
        _githubRepository = gitRepository,
        super(GithubReposState.initial(UserEntity.empty)) {
    on<GithubReposEvent>(_onGithubReposEvent);
    on<LoadGithubRepos>(_onLoadGithubRepos);
    on<SearchGithubReposByName>(_onSearchGithubReposByName);
  }

  final UserRepository _userRepository;
  final GithubRepositoryImpl _githubRepository;

  FutureOr<void> _onGithubReposEvent(
      GithubReposEvent event, Emitter<GithubReposState> emit) {}

  FutureOr<void> _onLoadGithubRepos(
      LoadGithubRepos event, Emitter<GithubReposState> emit) async {
    List<RepositoryEntity> repos = [];

    if (state.status == SearchScreenStatus.initial && state.user.isEmpty) {
      emit(state.copyWith(status: SearchScreenStatus.loading));

      UserEntity currentUser = await _userRepository.getUserById('user');
      if (currentUser.isEmpty) {
        currentUser = await _userRepository.createUser();
      }

      if (currentUser.isNotEmpty) {
        emit(state.copyWith(
          appStatus: AppStatus.authenticated,
          status: SearchScreenStatus.loadedSearchHistory,
          user: currentUser,
        ));
      } else {
        emit(
          state.copyWith(
            status: SearchScreenStatus.error,
            message:
                'User Not loaded. Some error occurred. Please try again later.',
          ),
        );
        return;
      }

      if (currentUser.recentSearches.isNotEmpty) {
        for (var query in currentUser.recentSearches) {
          var repo = await _githubRepository.getRepoById(repositoryId: query);
          repos.add(repo);
          emit(state.copyWith(
            appStatus: AppStatus.authenticated,
            status: SearchScreenStatus.loadedSearchHistory,
            searchResults: repos,
          ));
        }
      } else {
        emit(state.copyWith(
          status: SearchScreenStatus.error,
          message:
              "You have empty history. \n Click on search to start journey!",
        ));
      }
    }
  }

  FutureOr<void> _onSearchGithubReposByName(
      SearchGithubReposByName event, Emitter<GithubReposState> emit) async {
    emit(state.copyWith(status: SearchScreenStatus.loading));

    List<String> recentSearches = [];

    recentSearches.addAll(state.user.recentSearches);
    recentSearches.add(event.query);
    print("User: ${state.user}");
    print("Recent Searches: $recentSearches");

    _userRepository.updateUser(
        user: state.user.copyWith(recentSearches: recentSearches));
    List<RepositoryEntity> searchResults =
        await _githubRepository.searchRepositoryByName(
      query: event.query,
      resultsPerPage: state.resultsPerPage,
      pageNumber: state.currentPage,
    );

    if (searchResults.isEmpty) {
      emit(state.copyWith(
        status: SearchScreenStatus.error,
        message:
            "Nothing was find for your search. \n Please check the spelling",
      ));
    } else {
      emit(state.copyWith(
        status: SearchScreenStatus.loadedSearchResult,
        searchResults: searchResults,
      ));
    }

    print(
        "Length: ${searchResults.length}, searchResults in Bloc: $searchResults");
  }
}
