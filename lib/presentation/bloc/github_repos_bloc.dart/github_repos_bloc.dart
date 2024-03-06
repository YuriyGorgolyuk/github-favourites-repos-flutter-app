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
        super(GithubReposInitial()) {
    on<GithubReposEvent>(_onGithubReposEvent);
    on<LoadGithubRepos>(_onLoadGithubRepos);
  }

  final UserRepository _userRepository;
  final GithubRepositoryImpl _githubRepository;

  FutureOr<void> _onGithubReposEvent(
      GithubReposEvent event, Emitter<GithubReposState> emit) {}

  FutureOr<void> _onLoadGithubRepos(
      LoadGithubRepos event, Emitter<GithubReposState> emit) async {
    List<RepositoryEntity> repos = [];

    if (state is GithubReposInitial) {
      emit(GithubReposLoading());

      final UserEntity currentUser = await _userRepository.getUserById('user');

      if (currentUser.recentSearches.isNotEmpty) {
        for (var query in currentUser.recentSearches) {
          var repo = await _githubRepository.getRepoById(repositoryId: query);
          repos.add(repo);
        }
        emit(GithubReposLoaded(repos));
      } else {
        emit(const GithubReposError(
            "You have empty history. Click on search to start journey!"));
      }
    }
  }
}
