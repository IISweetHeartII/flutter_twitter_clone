import 'package:flutter/material.dart';

import 'routes.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  void didChangePrevious(Route? previousRoute) {
    super.didChangePrevious(previousRoute);
    Routes.sendNavigationEventToFirebase(settings.name);
  }

  @override
  void didChangeNext(Route? nextRoute) {
    super.didChangeNext(nextRoute);
    Routes.sendNavigationEventToFirebase(settings.name);
  }
}

class SlideLeftRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  SlideLeftRoute({required this.builder, RouteSettings? settings})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return builder(context);
          },
          settings: settings,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );

  @override
  void didChangePrevious(Route? previousRoute) {
    super.didChangePrevious(previousRoute);
    Routes.sendNavigationEventToFirebase(settings.name);
  }

  @override
  void didChangeNext(Route? nextRoute) {
    super.didChangeNext(nextRoute);
    Routes.sendNavigationEventToFirebase(settings.name);
  }
}
