class GithubLocalDataSource {
  final Map<String, Object?> userAuthLocalDataSource;

  GithubLocalDataSource() : userAuthLocalDataSource = <String, Object?>{};

  void write<T extends Object?>({required String key, T? value}) {
    userAuthLocalDataSource[key] = value;
  }

  T? read<T extends Object?>({required String key}) {
    final value = userAuthLocalDataSource[key];
    if (value is T) return value;
    return null;
  }

  bool contains({required String key}) {
    return userAuthLocalDataSource.containsKey(key);
  }

  void delete({required String key}) {
    userAuthLocalDataSource.remove(key);
  }
}
