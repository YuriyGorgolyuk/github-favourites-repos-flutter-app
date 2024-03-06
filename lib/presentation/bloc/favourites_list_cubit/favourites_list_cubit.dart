import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_favourites/domain/entities/repository_entity.dart';
import 'package:github_favourites/domain/entities/user_entity.dart';
import 'package:github_favourites/domain/repositories/github_favourites_repository.dart';

part 'favourites_list_state.dart';

class FavouritesListCubit extends Cubit<FavouritesListState> {
  FavouritesListCubit({required GithubRepositoryImpl gitRepository})
      : _gitRepository = gitRepository,
        super(const FavouritesListState());

  final GithubRepositoryImpl _gitRepository;

  void loadFavourites(UserEntity user) async {
    emit(FavouritesListState(status: FavouritesListStatus.loading));
    List<RepositoryEntity> repos = [];
    if (user.favouriteReposIds.isNotEmpty) {
      for (var id in user.favouriteReposIds) {
        var repo = await _gitRepository.getRepoById(repositoryId: id);
        repos.add(repo);
      }
      emit(FavouritesListState(
          status: FavouritesListStatus.loaded, favouriteRepos: repos));
    } else {
      emit(const FavouritesListState(
        status: FavouritesListStatus.error,
        message:
            "You have no favourites. \n Click on star while searching to add first favorite",
      ));
    }
  }
}
