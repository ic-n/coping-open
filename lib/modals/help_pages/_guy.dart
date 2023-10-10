import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Guy extends StatelessWidget {
  const Guy({
    required this.text,
    required this.face,
    super.key,
  });

  final String text;
  final String face;

  @override
  Widget build(final BuildContext context) {
    final s = (MediaQuery.of(context).size.width / 8).roundToDouble();
    final t = Theme.of(context);

    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: t.colorScheme.tertiaryContainer),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(width: s),
          Expanded(
              child: Center(
            child: Text(
              text,
              style: t.textTheme.headlineSmall!.copyWith(color: t.colorScheme.onTertiaryContainer),
            ),
          )),
          SvgPicture.asset(
            face,
            colorFilter: ColorFilter.mode(
              t.colorScheme.onTertiaryContainer,
              BlendMode.srcATop,
            ),
            width: s,
            height: s,
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
        ],
      ),
    );
  }
}
