part of 'bind3.dart';

mixin RouteController {
  final RouteCore core = RouteCore.get;

  static T get<T extends RouteController>([bool forcePush = false]) {
    var path = paths.containsKey(T) ? paths[T]!() : null;
    var service = RouteCore.get.tree.getService<T>(path);
    if (service == null) {
      throw Exception("RouteController.get<$T>(path: $path) not found service");
    }
    return service;
  }

  Future<void> initController();
  Future<void> disposeController();

  late RouteNode _routeInfo;
  RouteNode get routeInfo => _routeInfo;

  set routeInfo(RouteNode value) {
    _routeInfo = value;
    paths[runtimeType] = () => routeInfo.fullPath;
  }

  ///for navigation with controller
  StackRouter? _router;

  ///for navigation with controller
  StackRouter? get router => _router;

  ///for navigation with controller
  set router(StackRouter? value) {
    _router = value;
    core.currentRouter = value;
  }
  String get name => routeInfo.name; //path.split('/').last;
  String get path => routeInfo.fullPath;
  static final Map<Type, String Function()> paths = {};

  navigateRoute([StackRouter? sRouter, bool useName = false]) =>
      (sRouter ?? router)?.navigateNamed(useName ? name : path);

  pushRoute([StackRouter? sRouter, bool useName = false]) =>
      (sRouter ?? router)?.pushNamed(
          useName ? name : (path.startsWith('/') ? path.substring(1) : path));

  replaceRoute([StackRouter? sRouter, bool useName = false]) =>
      (sRouter ?? router)?.replaceNamed(
          useName ? name : (path.startsWith('/') ? path.substring(1) : path));

  navigateTo<T extends RouteController>({bool useName = false, RouteController? rc}) {
    rc ??= RouteController.get<T>();
    router?.navigateNamed(useName ? rc.name : rc.path);
  }

  pushTo<T extends RouteController>({bool useName = false, RouteController? rc}) {
    rc ??= RouteController.get<T>();
    router?.pushNamed(useName
        ? rc.name
        : (rc.path.startsWith('/') ? rc.path.substring(1) : rc.path));
  }

  replaceTo<T extends RouteController>({bool useName = false, RouteController? rc}) {
    rc ??= RouteController.get<T>();
    router?.replaceNamed(useName
        ? rc.name
        : (rc.path.startsWith('/') ? rc.path.substring(1) : rc.path));
  }
}
