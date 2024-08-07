part of 'bind3.dart';

abstract class BindStateController<T extends StatefulWidget,
    E extends RouteController> extends State<T> {
  final E routeController = RouteController.get<E>();

  @override
  void initState() {
    super.initState();
    routeController.router = AutoRouter.of(context);
    routeController.initController();
  }

  @override
  void dispose() {
    routeController.disposeController();
    super.dispose();
  }
}
