import 'dart:async';
import 'dart:ui';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  const Modal({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(final BuildContext context) => MetaModal(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                  },
                  icon: SvgIcon(assetPath: Assets.icons.arrowBack),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Opacity(
                  opacity: 0,
                  child: IconButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                    },
                    icon: SvgIcon(assetPath: Assets.icons.arrowBack),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(child: child),
        ],
      ));
}

class MetaModal extends StatelessWidget {
  const MetaModal({
    required this.body,
    this.color,
    super.key,
  });

  final Widget body;
  final Color? color;

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.only(top: 8 * 10, left: 8, right: 8),
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8 * 3),
              topRight: Radius.circular(8 * 3),
            ),
          ),
          child: SafeArea(
            left: false,
            top: false,
            right: false,
            minimum: const EdgeInsets.only(bottom: 16),
            child: body,
          ),
        ),
      );
}

void openModal(final BuildContext parentContext, final Widget content) {
  unawaited(Navigator.of(parentContext).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black.withOpacity(.5),
      pageBuilder: (final context, final animation, final _) => content,
      // transitionsBuilder: (ctx, anim1, anim2, child) =>  FadeTransition(
      //     child: child,
      //     opacity: anim1,
      //   ),
      // ),
      transitionsBuilder: (final context, final animation, final _, final child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.linear,
        )),
        child: Container(
          key: GlobalKey(),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8 * animation.value, sigmaY: 8 * animation.value),
            child: child,
          ),
        ),
      ),
    ),
  ));
}
