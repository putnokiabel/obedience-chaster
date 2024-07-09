import 'package:flutter/material.dart';

enum Themes {
  red(
    'Red',
    Color(0xFF801919),
    Color.fromRGBO(255, 255, 255, 0.88),
    Color(0xffCA8C09),
    Color.fromRGBO(255, 255, 255, 0.88),
  );

  const Themes(
    this.displayName,
    this.primary,
    this.onPrimary,
    this.secondary,
    this.onSecondary,
  );

  final String displayName;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;

  ThemeData getData(bool darkMode) {
    return ThemeData(
      useMaterial3: true,
      brightness: darkMode ? Brightness.dark : Brightness.light,
      primaryColor: primary,
      highlightColor: onPrimary.withOpacity(0.04),
      colorScheme: ColorScheme(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: const Color(0xFFC30C21),
        onError: Colors.white,
        surface: darkMode ? const Color(0xff28272e) : const Color(0xFFF7ECE6),
        onSurface: darkMode
            ? Colors.white.withOpacity(0.8)
            : Colors.black.withOpacity(0.8),
      ),
      fontFamily: 'Figtree',
      fontFamilyFallback: const ['AppleColorEmoji'],
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          fontFamily: 'Figtree',
          fontSize: Typography.englishLike2021.titleMedium!.fontSize,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Figtree',
          fontSize: Typography.englishLike2021.bodyMedium!.fontSize,
        ),
      ),
    );
  }
}
