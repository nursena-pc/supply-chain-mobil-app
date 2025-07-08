import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ThemeToggleTile extends StatelessWidget {
  const ThemeToggleTile({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final isDark = provider.themeMode == ThemeMode.dark;

    return SwitchListTile(
      secondary: const Icon(Icons.dark_mode),
      title: const Text("Koyu Tema"),
      value: isDark,
      onChanged: (value) => provider.toggleTheme(value),
    );
  }
}
