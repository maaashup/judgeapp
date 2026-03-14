import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String text;

  const EmptyState({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: cs.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
