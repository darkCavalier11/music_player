import 'package:flutter/material.dart';
import 'package:music_player/utils/swatch_generator.dart';

class AppTheme {
  static ThemeData get getTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      primarySwatch: SwatchGenerator.generateMaterialColor(
        const Color.fromRGBO(38, 65, 60, 1),
      ),
      colorScheme: const ColorScheme.light(
        secondary: Colors.deepOrangeAccent,
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
