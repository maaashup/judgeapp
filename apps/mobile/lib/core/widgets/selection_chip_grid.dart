import 'package:flutter/material.dart';

class SelectionChipGrid extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const SelectionChipGrid({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final selected = selectedValue == option;
        return GestureDetector(
          onTap: () => onSelected(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: selected
                  ? cs.primary
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.04)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? Colors.white
                    : cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
