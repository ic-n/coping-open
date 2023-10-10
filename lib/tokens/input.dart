import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    required this.title, required this.ctrl, required this.autocorrect, super.key,
    this.obscureText = false,
  });

  final String title;
  final TextEditingController ctrl;
  final bool autocorrect;
  final bool obscureText;

  @override
  Widget build(final BuildContext context) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.centerLeft,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: ctrl,
            builder: (final context, final value, final child) => value.text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: t.textTheme.bodySmall!.copyWith(
                          color: t.hintColor,
                        ),
                      ),
                    )
                  : const SizedBox(),
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: ctrl,
            autocorrect: autocorrect,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: title,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
