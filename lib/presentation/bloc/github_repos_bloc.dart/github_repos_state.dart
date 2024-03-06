part of 'github_repos_bloc.dart';

sealed class GithubReposState extends Equatable {
  const GithubReposState();

  @override
  List<Object> get props => [];
}

final class GithubReposInitial extends GithubReposState {}

final class GithubReposLoading extends GithubReposState {}

final class GithubReposLoaded extends GithubReposState {
  final List<RepositoryEntity> repositories;

  const GithubReposLoaded(this.repositories);

  @override
  List<Object> get props => [repositories];
}

final class GithubReposError extends GithubReposState {
  final String message;

  const GithubReposError(this.message);

  @override
  List<Object> get props => [message];
}
