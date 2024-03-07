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
        super(const GithubReposState.initial(UserEntity.empty)) {
    on<GithubReposEvent>(_onGithubReposEvent);
    on<LoadGithubRepos>(_onLoadGithubRepos);
    on<SearchGithubReposByName>(_onSearchGithubReposByName);
    on<StarStatusToggled>(_onStarStatusToggled);
  }

  final UserRepository _userRepository;
  final GithubRepositoryImpl _githubRepository;

  FutureOr<void> _onGithubReposEvent(
      GithubReposEvent event, Emitter<GithubReposState> emit) {}

  FutureOr<void> _onLoadGithubRepos(
      LoadGithubRepos event, Emitter<GithubReposState> emit) async {
    emit(state.copyWith(status: SearchScreenStatus.loading));

    UserEntity currentUser = await _userRepository.getUserById('user');

    /// need to simulate login and use init. in prod app this will be done in separate bloc.
    if (currentUser.isEmpty) {
      currentUser = await _userRepository.createUser();
    }

    if (currentUser.isNotEmpty) {
      emit(state.copyWith(
        appStatus: AppStatus.authenticated,
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

    /// Load starred repos with names also will be be done on user init.
    for (var id in currentUser.favouriteReposIds) {
      await _githubRepository.updateGitRepository(
          gitRepository: RepositoryEntity(
        id: id,
        isStarred: true,
        name: currentUser
            .favouriteReposNames[currentUser.favouriteReposIds.indexOf(id)],
      ));
    }

    if (currentUser.recentSearches.isNotEmpty) {
      emit(state.copyWith(
        status: SearchScreenStatus.loadedSearchHistory,
      ));
    } else {
      emit(state.copyWith(
        status: SearchScreenStatus.error,
        message: "You have empty history. \n Click on search to start journey!",
      ));
    }
  }

  FutureOr<void> _onSearchGithubReposByName(
      SearchGithubReposByName event, Emitter<GithubReposState> emit) async {
    emit(state.copyWith(
      status: SearchScreenStatus.loading,
      query: event.query,
    ));

    List<String> recentSearches = [];

    recentSearches.addAll(state.user.recentSearches);
    if (!recentSearches.contains(event.query)) {
      recentSearches.add(event.query);
    }

    final updatedUser = await _userRepository.updateUser(
        user: state.user.copyWith(recentSearches: recentSearches));

    // search in github
    List<RepositoryEntity> searchResults =
        await _githubRepository.searchRepositoryByName(
      query: event.query,
      resultsPerPage: state.resultsPerPage,
      pageNumber: state.currentPage,
    );

    List<RepositoryEntity> searchWithStarredRepos = [];
    // check if search results contans any starred repos
    for (var repo in searchResults) {
      if (state.user.favouriteReposIds.contains(repo.id)) {
        searchWithStarredRepos.add(repo.copyWith(isStarred: true));
      } else {
        searchWithStarredRepos.add(repo);
      }
    }

    if (searchResults.isEmpty) {
      emit(state.copyWith(
        status: SearchScreenStatus.error,
        message:
            "Nothing was find for your search. \n Please check the spelling",
      ));
    } else {
      emit(state.copyWith(
        user: updatedUser,
        status: SearchScreenStatus.loadedSearchResult,
        searchResults: searchWithStarredRepos,
      ));
    }
  }

  FutureOr<void> _onStarStatusToggled(
      StarStatusToggled event, Emitter<GithubReposState> emit) async {
    List<int> favouriteReposIds = [];
    List<String> favouriteReposNames = [];
    List<RepositoryEntity> searchResults = [];
    bool updatedStar = !event.repository.isStarred!;

    favouriteReposIds.addAll(state.user.favouriteReposIds);
    favouriteReposNames.addAll(state.user.favouriteReposNames);
    searchResults.addAll(state.searchResults);

    int index =
        searchResults.indexWhere((repo) => repo.id == event.repository.id);
    if (index != -1) {
      searchResults[index] = event.repository.copyWith(isStarred: updatedStar);
    } else {
      searchResults.add(event.repository.copyWith(isStarred: updatedStar));
    }

    /// a bit complex because selected solution for persistent can't handle entire object to store.
    if (state.user.favouriteReposIds.contains(event.repository.id)) {
      favouriteReposIds = state.user.favouriteReposIds;
      favouriteReposIds.remove(event.repository.id);
      favouriteReposNames = state.user.favouriteReposNames;
      favouriteReposNames.remove(event.repository.name);
    } else {
      favouriteReposIds.add(event.repository.id!);
      favouriteReposNames.add(event.repository.name!);
    }
    final updatedUser = await _userRepository.updateUser(
      user: state.user.copyWith(
        favouriteReposIds: favouriteReposIds,
        favouriteReposNames: favouriteReposNames,
      ),
    );

    await _githubRepository.updateGitRepository(
      gitRepository: event.repository.copyWith(
        isStarred: updatedStar,
      ),
    );

    emit(state.copyWith(
      searchResults: searchResults,
      user: updatedUser,
      message:
          updatedStar ? "Repository is starred" : "Repository is unstarred",
    ));
  }
}
