import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon({
    required this.assetPath,
    super.key,
    this.sizeOffset = 0,
    this.color,
  });

  final String assetPath;
  final double sizeOffset;
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    final iconColor = ColorFilter.mode(
      color ?? Theme.of(context).iconTheme.color!,
      BlendMode.srcATop,
    );

    return SvgPicture.asset(
      assetPath,
      colorFilter: iconColor,
      width: 22 - sizeOffset,
      height: 22 - sizeOffset,
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
  }
}
