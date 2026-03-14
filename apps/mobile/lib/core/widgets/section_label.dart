import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}
