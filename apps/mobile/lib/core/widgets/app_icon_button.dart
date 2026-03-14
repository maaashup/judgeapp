import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const AppIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      color: cs.onSurface.withValues(alpha: 0.5),
      iconSize: 26,
    );
  }
}
