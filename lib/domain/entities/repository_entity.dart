import 'package:equatable/equatable.dart';

class RepositoryEntity extends Equatable {
  const RepositoryEntity({
    this.name,
    this.id,
    this.fullName,
    this.htmlUrl,
    this.cloneUrl,
    this.isStarred,
  });

  final String? name;
  final int? id;
  final String? fullName;
  final String? htmlUrl;
  final String? cloneUrl;
  final bool? isStarred;

  static const RepositoryEntity empty = RepositoryEntity(
    name: '',
    id: 0,
    fullName: '',
    htmlUrl: '',
    cloneUrl: '',
    isStarred: false,
  );

  bool get isEmpty => this == RepositoryEntity.empty;
  bool get isNotEmpty => this != RepositoryEntity.empty;

  RepositoryEntity copyWith({
    String? name,
    int? id,
    String? fullName,
    String? htmlUrl,
    String? cloneUrl,
    bool? isStarred,
  }) {
    return RepositoryEntity(
      name: name ?? this.name,
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      cloneUrl: cloneUrl ?? this.cloneUrl,
      isStarred: isStarred ?? this.isStarred,
    );
  }

  @override
  List<Object?> get props => [name, id, fullName, htmlUrl, cloneUrl, isStarred];
}
