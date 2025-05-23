part of 'bind3.dart';

class RouteCore extends RouteCoreBase {
  static final RouteCore get = RouteCore._();

  RouteCore._();

  factory RouteCore.create(
      RepositoriesContainerBase repositoryContainer, AppRouterBase appRouter) {
    AppRouterBase.singleton = appRouter;

    if (!get.initialized) {
      get._load(repositoryContainer, appRouter);
    }
    return get;
  }
}

abstract class RouteCoreBase {
  bool initialized = false;
  RepositoriesContainerBase container = EmptyRepositoriesContainer();
  late RouteNode tree;
  StackRouter? currentRouter;

  Future<void> _load(
      RepositoriesContainerBase container, AppRouterBase appRouter) async {
    this.container = container;

    tree = appRouter.infoRoute;
    await this.container.initialize();

    initialized = true;
  }
}
