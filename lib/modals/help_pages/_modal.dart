import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/_handed.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';

class ModalDecoration extends StatelessWidget {
  const ModalDecoration({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgIcon(
                assetPath: Assets.icons.arrowBack,
                sizeOffset: 4,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            Opacity(
              opacity: 0,
              child: IconButton(
                onPressed: () {},
                icon: SvgIcon(
                  assetPath: Assets.icons.arrowBack,
                  sizeOffset: 4,
                ),
              ),
            ),
          ],
        ),
      );
}

class ModalContainer extends StatelessWidget {
  const ModalContainer({
    required this.title,
    required this.child,
    this.computeTop,
    this.computeLeft,
    super.key,
  });

  final String title;
  final double Function(double s, double av)? computeTop;
  final double Function(double s, double av)? computeLeft;
  final Column child;

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.only(left: 8 * 4, right: 8 * 4, top: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          transform: Matrix4.translationValues(0.0, 16, 0.0),
          child: Column(
            children: [
              ModalDecoration(title: title),
              (computeLeft != null && computeTop != null)
                  ? Handed(
                      computeTop: computeTop!,
                      computeLeft: computeLeft!,
                      duration: const Duration(seconds: 10),
                      child: child,
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: child,
                    ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      );
}
