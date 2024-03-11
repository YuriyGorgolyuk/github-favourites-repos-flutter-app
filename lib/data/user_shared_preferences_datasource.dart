import 'package:github_favourites/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferencesDatasource {
  UserSharedPreferencesDatasource(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  Future<UserEntity> loadUser({required UserEntity currentUser}) async {
    final recentSearches = sharedPreferences.getStringList('recentSearches');
    final favouriteReposIds =
        sharedPreferences.getStringList('favouriteReposIds');
    final favouriteReposNames =
        sharedPreferences.getStringList('favouriteReposNames');

    UserEntity updatedUser = currentUser.copyWith(
      recentSearches: recentSearches ?? [],
      favouriteReposIds:
          favouriteReposIds?.map((e) => int.parse(e)).toList() ?? [],
      favouriteReposNames: favouriteReposNames ?? [],
    );

    return updatedUser;
  }

  Future<void> updateUser({required UserEntity user}) async {
    sharedPreferences.setStringList('recentSearches', user.recentSearches);
    sharedPreferences.setStringList(
      'favouriteReposIds',
      user.favouriteReposIds.map((e) => e.toString()).toList(),
    );
    sharedPreferences.setStringList(
      'favouriteReposNames',
      user.favouriteReposNames,
    );
  }

  Future<void> deleteUser() async {
    sharedPreferences.remove('recentSearches');
    sharedPreferences.remove('favouriteReposIds');
    sharedPreferences.remove('favouriteReposNames');
  }
}
