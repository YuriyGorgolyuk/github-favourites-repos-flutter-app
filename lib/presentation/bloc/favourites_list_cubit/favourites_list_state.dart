part of 'favourites_list_cubit.dart';

sealed class FavouritesListState extends Equatable {
  const FavouritesListState();

  @override
  List<Object> get props => [];
}

final class FavouritesListInitial extends FavouritesListState {}

final class FavouritesListLoading extends FavouritesListState {}

final class FavouritesListLoaded extends FavouritesListState {
  final List<int> favouriteRepos;

  const FavouritesListLoaded(this.favouriteRepos);

  @override
  List<Object> get props => [favouriteRepos];
}
