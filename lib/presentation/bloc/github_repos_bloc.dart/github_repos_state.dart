part of 'github_repos_bloc.dart';

// app status should be in the separate bloc. Just add it here for simplicity
enum AppStatus { authenticated, initialisation, unauthenticated }

enum SearchScreenStatus {
  initial,
  loading,
  loadedSearchHistory,
  loadedSearchResult,
  error
}

class GithubReposState extends Equatable {
  const GithubReposState._({
    this.appStatus = AppStatus.unauthenticated,
    this.status = SearchScreenStatus.initial,
    this.user = UserEntity.empty,
    this.resultsPerPage = 15,
    this.currentPage = 1,
    this.message = '',
    this.searchResults = const [],
  });

  final UserEntity user;
  final AppStatus appStatus;
  final SearchScreenStatus status;
  final int resultsPerPage;
  final int currentPage;
  final String message;
  final List<RepositoryEntity> searchResults;

  const GithubReposState.initial(UserEntity user)
      : this._(appStatus: AppStatus.unauthenticated, user: user);

  GithubReposState copyWith({
    UserEntity? user,
    AppStatus? appStatus,
    SearchScreenStatus? status,
    int? resultsPerPage,
    int? currentPage,
    String? message,
    List<RepositoryEntity>? searchResults,
  }) {
    return GithubReposState._(
      user: user ?? this.user,
      appStatus: appStatus ?? this.appStatus,
      status: status ?? this.status,
      resultsPerPage: resultsPerPage ?? this.resultsPerPage,
      currentPage: currentPage ?? this.currentPage,
      message: message ?? this.message,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  @override
  List<Object> get props => [
        user,
        appStatus,
        status,
        resultsPerPage,
        currentPage,
        message,
        searchResults
      ];
}
