import 'package:flutter/material.dart';

class SlideRoute extends PageRouteBuilder {
  final Widget widget;
  final String screen;
  SlideRoute({this.widget, this.screen})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      settings:RouteSettings(name: screen)
  );
}