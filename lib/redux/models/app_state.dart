import 'package:flutter/material.dart';

class AppState {
  final UiState uiState;
  AppState({
    required this.uiState,
  });

  AppState copyWith({
    UiState? uiState,
  }) {
    return AppState(
      uiState: uiState ?? this.uiState,
    );
  }

  factory AppState.initial() {
    return AppState(
      uiState: UiState.initial(),
    );
  }

  @override
  String toString() => 'AppState(uiState: $uiState)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppState && other.uiState == uiState;
  }

  @override
  int get hashCode => uiState.hashCode;
}

class UiState {
  final ThemeMode themeMode;
  UiState({
    required this.themeMode,
  });

  factory UiState.initial() {
    return UiState(themeMode: ThemeMode.dark);
  }

  UiState copyWith({
    ThemeMode? themeMode,
  }) {
    return UiState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  String toString() => 'UiState(themeMode: $themeMode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UiState && other.themeMode == themeMode;
  }

  @override
  int get hashCode => themeMode.hashCode;
}
