import 'package:flutter/material.dart';

class GitFavouritesTheme {
  Color background = const Color(0xFFF9F9F9);
  // Layers
  Color layerOne = const Color(0xFFF2F2F2);

  // accent colors
  Color accentPrimary = const Color(0xFF1463F5);
  Color accentSecondary = const Color(0xFFE5EDFF);

  // text colors
  Color textPrimary = const Color(0xFF211814);
  Color textSecondary = const Color(0xFFBFBFBF);

  // text styles
  static TextStyle mainTextStyle = const TextStyle(
    fontFamily: "Raleway",
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0,
  );

  static TextStyle bodyTextStyle = const TextStyle(
    fontFamily: "Raleway",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Returns the light theme for the app
  ThemeData get light {
    ThemeData lightThemeData = ThemeData(
      scaffoldBackgroundColor: background,
      canvasColor: layerOne,
      primaryColor: accentPrimary,
      textTheme: TextTheme(
        titleLarge: mainTextStyle.copyWith(fontSize: 24),
        titleMedium: mainTextStyle,
        bodyLarge: bodyTextStyle.copyWith(fontSize: 18),
        bodyMedium: bodyTextStyle,
      ),
      colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        primary: accentPrimary,
        onPrimary: accentPrimary,
        onSecondary: accentSecondary,
        secondary: accentSecondary,
        background: background,
        error: Colors.red,
        onError: Colors.red,
        onBackground: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
    );

    return lightThemeData;
  }
}
