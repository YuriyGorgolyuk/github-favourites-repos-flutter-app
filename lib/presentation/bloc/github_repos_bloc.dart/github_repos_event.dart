part of 'github_repos_bloc.dart';

sealed class GithubReposEvent extends Equatable {
  const GithubReposEvent();

  @override
  List<Object> get props => [];
}

class LoadGithubRepos extends GithubReposEvent {
  const LoadGithubRepos();
}

class SearchGithubReposByName extends GithubReposEvent {
  final String query;

  const SearchGithubReposByName(this.query);

  @override
  List<Object> get props => [query];
}

class StarStatusToggled extends GithubReposEvent {
  final RepositoryEntity repository;

  const StarStatusToggled(this.repository);

  @override
  List<Object> get props => [repository];
}

class ClearSearchField extends GithubReposEvent {
  const ClearSearchField();
}

class ClearSearchHistory extends GithubReposEvent {
  const ClearSearchHistory();
}
