import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
