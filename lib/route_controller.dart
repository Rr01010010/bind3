part of 'bind3.dart';

abstract class RouteController {
  final RouteCore core = RouteCore.get;

  static T get<T extends RouteController>([bool forcePush = false]) {
    var path = paths.containsKey(T) ? paths[T]!() : null;
    var service = RouteCore.get.tree.getService<T>(path);
    if (service == null)
      throw Exception("RouteController.get<$T>(path: $path) not found service");
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
  StackRouter? router;
  String get name => routeInfo.name; //path.split('/').last;
  String get path => routeInfo.fullPath;
  static final Map<Type, String Function()> paths = {};

  navigateRoute([StackRouter? sRouter, useName = false]) =>
      (sRouter ?? router)?.navigateNamed(useName
          ? name
          : path); //(path.startsWith('/') ? path.substring(1) : path));

  pushRoute([StackRouter? sRouter, useName = false]) =>
      (sRouter ?? router)?.pushNamed(
          useName ? name : (path.startsWith('/') ? path.substring(1) : path));

  replaceRoute([StackRouter? sRouter, useName = false]) =>
      (sRouter ?? router)?.replaceNamed(
          useName ? name : (path.startsWith('/') ? path.substring(1) : path));
}
