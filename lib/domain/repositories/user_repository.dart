import 'package:github_favourites/data/github_local_datasource.dart';
import 'package:github_favourites/data/user_shared_preferences_datasource.dart';
import 'package:github_favourites/domain/entities/user_entity.dart';

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
    required this.preferences,
  });

  final GithubLocalDataSource localDataSource;
  final UserSharedPreferencesDatasource preferences;

  Future<UserEntity> createUser({UserEntity? user}) async {
    final currentUser = user ?? defaulUser;
    final updatedUser = preferences.loadUser(currentUser: currentUser);

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
    preferences.updateUser(user: user);
    localDataSource.write(key: 'user', value: user);
    return user;
  }

  Future<void> deleteUser({required String userId}) async {
    preferences.deleteUser();
    localDataSource.write(key: 'user', value: null);
    return;
  }
}
