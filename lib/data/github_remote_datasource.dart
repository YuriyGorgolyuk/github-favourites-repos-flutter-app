import 'package:github_favourites/domain/entities/repository_entity.dart';

abstract class GithubRemoteDataSource {
  Future<RepositoryEntity> getGitById({required var repositoryId});
  Future<RepositoryEntity> updateGitRepository(
      {required RepositoryEntity gitRepository});
  Future<List<RepositoryEntity>> searchRepositoryByName(String query);
}

final RepositoryEntity repo1 = RepositoryEntity(
  name: 'repo1',
  id: 1,
  fullName: 'repo1',
  htmlUrl: ' ',
  cloneUrl: ' ',
);

class GithubClient implements GithubRemoteDataSource {
  @override
  Future<List<RepositoryEntity>> searchRepositoryByName(String query) async {
    await Future.delayed(const Duration(seconds: 2));
    return <RepositoryEntity>[repo1, repo1, repo1];
  }

  @override
  Future<RepositoryEntity> getGitById({required var repositoryId}) async {
    await Future.delayed(const Duration(seconds: 2));
    return repo1;
  }

  @override
  Future<RepositoryEntity> updateGitRepository(
      {required RepositoryEntity gitRepository}) async {
    await Future.delayed(const Duration(seconds: 2));
    return gitRepository;
  }
}
