import 'package:flutter/material.dart';
import 'package:music_player/utils/swatch_generator.dart';

class AppTheme {
  static ThemeData get getTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      primaryColor: const Color(0xff61c9a8),
      primarySwatch: SwatchGenerator.generateMaterialColor(
        const Color(0xff61c9a8),
      ),
      canvasColor: Colors.black,
      errorColor: Colors.redAccent,
      colorScheme: const ColorScheme.light(
        secondary: Colors.deepOrangeAccent,
        brightness: Brightness.dark,
      ),
    );
  }

  static ThemeData get getDarkTheme {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: Color.fromRGBO(254, 227, 214, 1),
        // surface: Color.fromRGBO(254, 227, 214, 1),
      ),
    );
  }
}
