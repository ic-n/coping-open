import 'package:flutter/material.dart';

class AnimatedCountedUp extends StatelessWidget {
  const AnimatedCountedUp({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(final BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (final Widget child, final Animation<double> animation) => DualTransitionBuilder(
          key: child.key,
          animation: animation,
          child: child,
          forwardBuilder: (final context, final animation, final child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: Curves.ease)).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
          reverseBuilder: (final context, final animation, final child) => SlideTransition(
            position: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).chain(CurveTween(curve: Curves.ease)).animate(animation),
            child: FadeTransition(
              opacity: animation.drive(Tween(begin: 1, end: 0)),
              child: child,
            ),
          ),
        ),
        child: child,
      );
}
