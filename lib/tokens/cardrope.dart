import 'package:flutter/material.dart';

class RopedCard extends StatelessWidget {
  const RopedCard({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      );
}

class CardRope extends StatelessWidget {
  const CardRope({
    required this.cards,
    super.key,
  });

  final List<Widget> cards;

  @override
  Widget build(final BuildContext context) {
    final List<Widget> ws = [];
    for (final card in cards) {
      ws.add(const SizedBox(
        height: 8,
      ));
      ws.add(card);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        shrinkWrap: true,
        reverse: true,
        children: ws.reversed.toList(),
      ),
    );
  }
}
