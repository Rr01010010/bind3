## Library purpose

bind3 is a library that allows you to bind routes to page controllers.
The point is to build the architectural base of a flutter project, based on a tree of pages with
singleton-controllers bounded to those pages.

## Current problem

Currently the library requires working with the auto_route navigator,
and is bound only to this navigator. By the end of August 2024, 
I intend to make the package independent, 
or if that fails, add support for other packages 
such as [Flutter Navigator 2.0](https://docs.flutter.dev/ui/navigation),
[go_router](https://pub.dev/packages/go_router),
[fluro](https://pub.dev/packages/fluro),
[beamer](https://pub.dev/packages/beamer),
[flutter_modular](https://pub.dev/packages/flutter_modular),
[flow_builder](https://pub.dev/packages/flow_builder),
[routefly](https://pub.dev/packages/routefly), and others

Also, the current version does not support complex routing with *guard* routes of auto_route

## Getting started

To start using the library you need to create your AppRouter

```dart
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter with AppRouterBase {
  @override
  RouteNode get infoRoute =>
      RouteNode(name: '/', page: GeneralWrapperRoute.page, children: [
        RouteNode(
          initial: true,
          page: OrdersMainRoute.page,
          name: "ordersMain",
          routeController: OrdersMainController(),
        ),
        RouteNode(
          initial: true,
          page: MenuMainRoute.page,
          name: "menuMain",
          routeController: MenuMainController(),
        ),
      ]);
}
```

1. Specify our router as the application router. 
2. Call RouteCore.create() to create the central bind3 node.
3. (optionally) Define your RepositoryContainer,
which requires initialization at the beginning of the application, along with the core initialization bind3 and replace the base EmptyRepositoryContainer to yours

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();
  late RouteCore routeCore = RouteCore.create(EmptyRepositoriesContainer(), _appRouter);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
    );
  }
}
```

## Usage

Pages must be marked with the @RoutePage() annotation, as in the auto_route package, but states must inherit BindStateController<YourPage,YourController which extends RouteController> if you wish to use a logical controller for the selected page

```dart
@RoutePage()
class MenuMainPage extends StatefulWidget {
  const MenuMainPage({super.key});
  @override
  State<MenuMainPage> createState() => _MenuMainPageState();
}
class _MenuMainPageState extends BindStateController<MenuMainPage, MenuMainController> {
  @override
  Widget build(BuildContext context) {
    ///You can access the page controller to display logic-dependent widgets
    print("${routeController.runtimeType}");
    // TODO: implement build
    throw UnimplementedError();
  }
  @override
  void didChangeDependencies() {
    ///Or for something other logic with controller
    print("${routeController.runtimeType}");
    super.didChangeDependencies();
  }
}
```

But you can simply extends from State as usual, if the page does not need a controller

```dart
class _MenuMainPageState extends State<MenuMainPage> {}
```

Your page controller must inherit from RouteController

This is an example of inheritance for working with Mobx state manager, later I will provide examples for working with Bloc/Cubit and others

```dart
class MenuMainController = MenuMainControllerBase with _$MenuMainController;

abstract class MenuMainControllerBase extends RouteController with Store {
  @observable
  ObservableList<String> titles = ObservableList();
  @action
  void add(String title) => titles.add(title);
  @action
  void removeAt(int index) => titles.removeAt(index);
  @action
  void removeTitle(String title) => titles.removeWhere((val) => val.compareTo(title) == 0);

  @action
  @override
  Future<void> initController() async {
  }
  @action
  @override
  Future<void> disposeController() async {
  }
}
```

Pay attention, that the controller implements the initController and disposeController methods. These methods are called when the page's initState and dispose methods are called.

## Additional information

This package is developed by one poor developer from Russia,
who works 15+ hours a day, so if you have a problem,
that needs an urgent solution, you can write to
[Github issues](https://github.com/Rr01010010/bind3/issues), 
but not a fact that I will react quickly.
If you have a desire to actively participate in the development
of the library (which I doubt) - [telegram](https://t.me/Rr01010010)

Thank you for choosing my library :heart:
