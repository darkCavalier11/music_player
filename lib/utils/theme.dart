import 'package:flutter/material.dart';
import 'package:music_player/utils/swatch_generator.dart';

class AppTheme {
  static ThemeData get getTheme {
    return ThemeData(
      primarySwatch: SwatchGenerator.generateMaterialColor(
        const Color.fromRGBO(38, 65, 60, 1),
      ),
    );
  }

  static ThemeData get getDarkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark().copyWith(
        primary: const Color.fromRGBO(38, 65, 60, 1),
        secondary: const Color.fromARGB(255, 70, 102, 242),
      ),
    );
  }
}
