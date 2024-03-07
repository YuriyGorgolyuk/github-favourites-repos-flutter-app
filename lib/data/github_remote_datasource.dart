import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_favourites/domain/entities/repository_entity.dart';
import 'package:http/http.dart' as http;

abstract class GithubRemoteDataSource {
  Future<RepositoryEntity> getGitById({required var repositoryId});
  Future<RepositoryEntity> updateGitRepository(
      {required RepositoryEntity gitRepository});
  Future<List<RepositoryEntity>> searchRepositoryByName(
    String query, {
    int? resultsPerPage,
    int? pageNumber,
  });
}

List<RepositoryEntity> parseJsonInBackground(String responseBody) {
  final parsed = json.decode(responseBody);
  final items = parsed['items'] as List<dynamic>;
  return items
      .map<RepositoryEntity>((json) => RepositoryEntity.fromJson(json))
      .toList();
}

class GithubClient implements GithubRemoteDataSource {
  @override
  Future<List<RepositoryEntity>> searchRepositoryByName(
    String query, {
    int? resultsPerPage = 15,
    int? pageNumber = 1,
  }) async {
    try {
      final response = await http.get(
          Uri.parse(
              'https://api.github.com/search/repositories?q=$query&per_page=$resultsPerPage&page=$pageNumber'),
          headers: {
            'Accept': 'application/vnd.github+json',
            'Authorization': 'Bearer ${dotenv.env['GITHUB_TOKEN']}',
            'X-GitHub-Api-Version': '2022-11-28'
          });
      if (response.statusCode == 200) {
        return compute(parseJsonInBackground, response.body);
      } else {
        throw Exception(
            'Failed to load repositories. Status code: ${response.statusCode}. message: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load repositories with error: $e');
    }
  }

  @override
  Future<RepositoryEntity> getGitById({required var repositoryId}) async {
    // to implement fetch from github
    return RepositoryEntity.empty;
  }

  @override
  Future<RepositoryEntity> updateGitRepository(
      {required RepositoryEntity gitRepository}) async {
    await Future.delayed(const Duration(milliseconds: 80));
    return gitRepository;
  }
}
