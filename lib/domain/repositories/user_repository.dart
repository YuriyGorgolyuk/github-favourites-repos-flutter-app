import 'package:github_favourites/data/github_local_datasource.dart';
import 'package:github_favourites/domain/entities/user_entity.dart';

// add defoult user for the app
UserEntity defaulUser = const UserEntity(
  userID: 'user',
  username: 'John Snow',
  email: 'johnsnow93@gmail.com',
  recentSearches: [],
  favouriteReposIds: [123, 456, 789],
);

class UserRepository {
  UserRepository({
    required this.localDataSource,
  });

  final GithubLocalDataSource localDataSource;

  Future<UserEntity> createUser({UserEntity? user}) async {
    final currentUser = user ?? defaulUser;
    localDataSource.write(key: 'user', value: currentUser);
    return currentUser;
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
    localDataSource.write(key: 'user', value: user);
    return user;
  }

  Future<void> deleteUser({required String userId}) async {
    localDataSource.write(key: 'user', value: null);
    return;
  }
}
