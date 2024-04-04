import 'package:flutter/material.dart';

class CupertinoSlideBackPageRoute extends PageRouteBuilder {
  final Widget page;
  CupertinoSlideBackPageRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0), // Slide from right to left
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn, // Use different curve for reverse animation
              )),
              child: child,
            );
          },
        );
}
