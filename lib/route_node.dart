part of 'bind3.dart';

class RouteNode {
  final bool initial;
  final PageInfo<dynamic> page;
  final RouteController? routeController;
  final String name;
  RouteNode? parent;
  final List<RouteNode>? children;

  RouteNode({
    this.initial = false,
    required this.page,
    this.routeController,
    required this.name,
    this.children,
  }) {
    children?.forEach((child) {
      child.parent = this;
      paths[child.name] = child;
    });
    routeController?.routeInfo = this;
  }

  T? getService<T extends RouteController>([String? path]) {
    path ??= RouteController.paths.containsKey(T)
        ? RouteController.paths[T]!()
        : null;

    if (path == null) return null;

    if (path.startsWith('/')) path = path.substring(1);
    var splits = path.split('/');
    var node = getNodeTree(splits);

    return node.routeController != null ? (node.routeController as T) : null;
  }

  RouteNode getNodeTree(List<String> splits) {
    if (splits.isEmpty) return this;
    if (paths.isEmpty) return this;
    if (splits.length == 1 && splits[0] == "") return this;

    if (!paths.containsKey(splits.first)) {
      return this;
    }
    if (paths[splits.first] == null) {
      return this;
    }

    if (splits.length > 1) {
      return paths[splits.first]!.getNodeTree(splits.sublist(1));
    }
    return paths[splits.first]!;
  }

  final Map<String, RouteNode?> paths = {};

  ///like: general/home/
  String? get parentPath => parent?.fullPath;
  String get fullPath {
    String? parent = parentPath;
    if (parent == null) return name;

    return parent.endsWith('/')
        ? "${parentPath ?? ""}$name"
        : "${parentPath ?? ""}/$name";
  }

  AutoRoute get route => AutoRoute(
        initial: initial,
        page: page,
        path: name,
        children: children?.map((info) => info.route).toList(),
      );
}

class RouteNodeCupertino extends RouteNode {
  RouteNodeCupertino({
    super.initial = false,
    required super.page,
    super.routeController,
    required super.name,
    super.children,
  });

  @override
  AutoRoute get route => CupertinoRoute(
        initial: initial,
        page: page,
        path: name,
        children: children?.map((info) => info.route).toList(),
      );
}

class RouteNodeMaterial extends RouteNode {
  RouteNodeMaterial({
    super.initial = false,
    required super.page,
    super.routeController,
    required super.name,
    super.children,
  });

  @override
  AutoRoute get route => MaterialRoute(
        initial: initial,
        page: page,
        path: name,
        children: children?.map((info) => info.route).toList(),
      );
}
