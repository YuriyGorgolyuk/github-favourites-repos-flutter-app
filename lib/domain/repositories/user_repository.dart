import 'package:github_favourites/data/github_local_datasource.dart';
import 'package:github_favourites/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

// add default user for the app cause no login
UserEntity defaulUser = const UserEntity(
  userID: 'user',
  username: 'John Snow',
  email: 'johnsnow93@gmail.com',
  recentSearches: [],
  favouriteReposIds: [],
);

class UserRepository {
  UserRepository({
    required this.localDataSource,
    required this.sharedPreferences,
  });

  final GithubLocalDataSource localDataSource;
  final SharedPreferences sharedPreferences;

  Future<UserEntity> createUser({UserEntity? user}) async {
    final currentUser = user ?? defaulUser;

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

    localDataSource.write(key: 'user', value: updatedUser);
    return updatedUser;
  }

  Future<UserEntity> getUserById(String userId) async {
    // simulate fetch user data from remote database
    await Future.delayed(const Duration(seconds: 3));

    if (localDataSource.read(key: userId) != null) {
      return localDataSource.read(key: userId)!;
    }
    return UserEntity.empty;
  }

  Future<UserEntity> updateUser({required UserEntity user}) async {
    sharedPreferences.setStringList('recentSearches', user.recentSearches);
    sharedPreferences.setStringList(
      'favouriteReposIds',
      user.favouriteReposIds.map((e) => e.toString()).toList(),
    );
    sharedPreferences.setStringList(
      'favouriteReposNames',
      user.favouriteReposNames,
    );

    localDataSource.write(key: 'user', value: user);
    return user;
  }

  Future<void> deleteUser({required String userId}) async {
    sharedPreferences.remove('recentSearches');
    sharedPreferences.remove('favouriteReposIds');
    sharedPreferences.remove('favouriteReposNames');
    localDataSource.write(key: 'user', value: null);
    return;
  }
}
