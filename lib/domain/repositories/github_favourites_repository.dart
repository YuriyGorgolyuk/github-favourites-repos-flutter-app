import 'package:github_favourites/data/github_local_datasource.dart';
import 'package:github_favourites/data/github_remote_datasource.dart';
import 'package:github_favourites/domain/entities/repository_entity.dart';

class GithubRepositoryImpl {
  GithubRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final GithubRemoteDataSource remoteDataSource;
  final GithubLocalDataSource localDataSource;

  Future<List<RepositoryEntity>> searchRepositoryByName(
      {required String query}) async {
    var searchResults = await remoteDataSource.searchRepositoryByName(query);

    return searchResults;
  }

  Future<RepositoryEntity> getRepoById({required var repositoryId}) async {
    if (localDataSource.read(key: repositoryId.toString()) != null) {
      return localDataSource.read(key: repositoryId.toString())!;
    }

    var gitRepository =
        await remoteDataSource.getGitById(repositoryId: repositoryId);

    return gitRepository;
  }

  Future<RepositoryEntity> updateGitRepository({
    required RepositoryEntity gitRepository,
  }) async {
    localDataSource.write(
        key: gitRepository.id.toString(), value: gitRepository);

    var updatedRepo = await remoteDataSource.updateGitRepository(
        gitRepository: gitRepository);

    return updatedRepo;
  }
}
