import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_favourites/domain/repositories/user_repository.dart';

part 'favourites_list_state.dart';

class FavouritesListCubit extends Cubit<FavouritesListState> {
  FavouritesListCubit({required UserRepository repository})
      : _userRepository = repository,
        super(FavouritesListInitial());

  final UserRepository _userRepository;

  void loadFavourites(String userId) async {
    emit(FavouritesListLoading());
    await _userRepository.getUserById(userId).then((user) {
      emit(FavouritesListLoaded(user.favouriteReposIds));
    });
  }
}
