import 'dart:math';

import 'package:flutter/material.dart';

/// A color Swatch generator from a single color.
class SwatchGenerator {
  /// generate a [MaterialColor] based on the color by doing an interpolation
  /// between black -> current color -> white to generate light and darker shades
  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(
      color.value,
      {
        50: _tintColor(color, 0.9),
        100: _tintColor(color, 0.8),
        200: _tintColor(color, 0.6),
        300: _tintColor(color, 0.4),
        400: _tintColor(color, 0.2),
        500: color,
        600: _shadeColor(color, 0.1),
        700: _shadeColor(color, 0.2),
        800: _shadeColor(color, 0.3),
        900: _shadeColor(color, 0.4),
      },
    );
  }

  static int _tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  /// create lighter shade of the color depending upon the factor.
  /// A factor of 1 means white and 0 means current color.
  static Color _tintColor(Color color, double factor) => Color.fromRGBO(
      _tintValue(color.red, factor),
      _tintValue(color.green, factor),
      _tintValue(color.blue, factor),
      1);

  static int _shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  /// create darker shade of the color depending upon the factor.
  /// A factor of 1 means black and 0 means current color.
  static Color _shadeColor(Color color, double factor) => Color.fromRGBO(
      _shadeValue(color.red, factor),
      _shadeValue(color.green, factor),
      _shadeValue(color.blue, factor),
      1);
}