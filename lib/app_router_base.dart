part of 'bind3.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class EmptyRouter extends AppRouterBase {
  @override
  RouteNode get infoRoute => throw Exception(
      "Не реализован AppRouterBase и/или не передан в синглтон");
}

mixin class AppRouterBase implements RootStackRouter {
  static AppRouterBase? _singleton;
  static set singleton(AppRouterBase router) => _singleton ??= router;
  static AppRouterBase get singleton {
    _singleton ??= EmptyRouter();
    return _singleton!;
  }

  @override
  List<AutoRoute> get routes => [infoRoute.route];
  RouteNode get infoRoute;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
