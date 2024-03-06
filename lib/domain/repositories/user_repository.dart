import 'package:github_favourites/data/github_local_datasource.dart';
import 'package:github_favourites/domain/entities/user_entity.dart';

class UserRepository {
  UserRepository({
    required this.localDataSource,
  });

  final GithubLocalDataSource localDataSource;

  Future<UserEntity> createUser({required UserEntity user}) async {
    localDataSource.write(key: 'user', value: user);
    return user;
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
