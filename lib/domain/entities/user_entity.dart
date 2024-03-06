import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userID;
  final String? username;
  final String? email;
  final List<int> favouriteReposIds;
  final List<String> recentSearches;

  const UserEntity({
    this.userID,
    this.username,
    this.email,
    this.favouriteReposIds = const [],
    this.recentSearches = const [],
  });

  static const empty = UserEntity(
    userID: '',
    username: '',
    email: '',
    favouriteReposIds: [],
    recentSearches: [],
  );

  bool get isEmpty => this == UserEntity.empty;
  bool get isNotEmpty => this != UserEntity.empty;

  copyWith({
    String? userID,
    String? username,
    String? email,
    List<int>? favouriteReposIds,
    List<String>? recentSearches,
  }) {
    return UserEntity(
      userID: userID ?? this.userID,
      username: username ?? this.username,
      email: email ?? this.email,
      favouriteReposIds: favouriteReposIds ?? this.favouriteReposIds,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }

  @override
  List<Object?> get props =>
      [userID, username, email, favouriteReposIds, recentSearches];
}
