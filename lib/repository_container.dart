part of 'bind3.dart';

class EmptyRepositoriesContainer with RepositoriesContainerBase {
  @override
  bool get loading {
    throw Exception(
        "Не реализован RepositoryContainerBase и/или не передан в RouteCore");
  }

  @override
  Future<void> initialize() async {}
}

mixin RepositoriesContainerBase {
  bool get loading;
  Future<void> initialize();
}
