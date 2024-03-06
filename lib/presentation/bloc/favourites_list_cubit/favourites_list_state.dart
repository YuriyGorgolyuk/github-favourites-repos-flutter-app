part of 'favourites_list_cubit.dart';

enum FavouritesListStatus { initial, loading, loaded, error }

final class FavouritesListState extends Equatable {
  const FavouritesListState({
    this.status = FavouritesListStatus.initial,
    this.favouriteRepos = const [],
    this.message = '',
  });

  final FavouritesListStatus status;
  final List<RepositoryEntity> favouriteRepos;
  final String message;

  @override
  List<Object> get props => [favouriteRepos];
}
