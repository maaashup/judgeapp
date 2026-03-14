import 'package:flutter/material.dart';

class DateTimePickerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isFilled;
  final VoidCallback onTap;

  const DateTimePickerTile({
    super.key,
    required this.icon,
    required this.text,
    required this.isFilled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fillColor = Theme.of(context).inputDecorationTheme.fillColor;

    return Material(
      color: fillColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isFilled
                    ? cs.primary
                    : cs.onSurface.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isFilled ? FontWeight.w500 : FontWeight.w400,
                    color: isFilled
                        ? cs.onSurface
                        : cs.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
