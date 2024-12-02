import 'package:flutter/material.dart';

class FadeTransitionPage extends PageRouteBuilder {
  final Widget page;

  FadeTransitionPage({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
