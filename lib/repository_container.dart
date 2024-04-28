part of 'bind3.dart';

class EmptyRepositoriesContainer extends RepositoriesContainerBase {
  @override
  bool get loading {throw Exception("Не реализован RepositoryContainerBase и/или не передан в RouteCore");}
  @override
  Future<void> initialize() async {}
}
abstract class RepositoriesContainerBase {
  bool get loading;
  Future<void> initialize();
}