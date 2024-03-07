import 'package:flutter/material.dart';

class GitFavouritesTheme {
  static const Color background = Color(0xFFF9F9F9);
  // Layers
  static const Color layerOne = Color.fromRGBO(242, 242, 242, 1);

  // accent colors
  static const Color accentPrimary = Color(0xFF1463F5);
  static const Color accentSecondary = Color.fromRGBO(229, 237, 255, 1);

  // text colors
  static const Color textPrimary = Color(0xFF211814);
  static const Color textPlaceholder = Color(0xFFBFBFBF);

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
    height: 1.2,
    letterSpacing: 0,
  );

  /// Returns the light theme for the app
  static ThemeData get light {
    const outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: layerOne,
        width: 2,
      ),
    );
    var buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(accentPrimary),
      iconColor: MaterialStateProperty.all(background),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    ThemeData lightThemeData = ThemeData(
      scaffoldBackgroundColor: background,
      canvasColor: layerOne,
      primaryColor: accentPrimary,
      textTheme: TextTheme(
        titleLarge: mainTextStyle.copyWith(fontSize: 24),
        titleMedium: mainTextStyle,
        bodyMedium: bodyTextStyle,
      ),
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: accentPrimary,
        onPrimary: accentPrimary,
        secondary: accentSecondary,
        onSecondary: accentSecondary,
        background: layerOne,
        tertiary: textPlaceholder,
        error: Colors.red,
        onBackground: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
      ),

      /// Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: layerOne,
        focusColor: accentSecondary,
        disabledBorder: outlineInputBorder,
        hintStyle: bodyTextStyle,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder.copyWith(
            borderSide: const BorderSide(color: accentPrimary)),
        errorBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
      ),

      /// Button theme
      iconButtonTheme: IconButtonThemeData(style: buttonStyle),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        titleTextStyle: mainTextStyle.copyWith(
          fontSize: 16,
          color: textPrimary,
        ),
      ),

      cardTheme: CardTheme(
        color: layerOne,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      listTileTheme: ListTileThemeData(
        textColor: textPrimary,
        titleTextStyle: bodyTextStyle,
      ),
    );

    return lightThemeData;
  }
}
