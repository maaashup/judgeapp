import 'package:flutter/material.dart';
import 'app/app_shell_page.dart';
import 'core/controllers/theme_controller.dart';
import 'core/theme/app_theme.dart';

final themeController = ThemeController();

void main() {
  runApp(const JudgeApp());
}

class JudgeApp extends StatelessWidget {
  const JudgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (_, mode, _) {
        return MaterialApp(
          title: 'Judge',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: const AppShellPage(),
        );
      },
    );
  }
}
