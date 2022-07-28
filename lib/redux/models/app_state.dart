import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
  final AudioPlayer audioPlayer;
  UiState({
    required this.audioPlayer,
    required this.themeMode,
  });

  factory UiState.initial() {
    return UiState(themeMode: ThemeMode.light, audioPlayer: AudioPlayer());
  }

  UiState copyWith({
    ThemeMode? themeMode,
    AudioPlayer? audioPlayer,
  }) {
    return UiState(
      themeMode: themeMode ?? this.themeMode,
      audioPlayer: audioPlayer ?? this.audioPlayer,
    );
  }

  @override
  String toString() =>
      'UiState(themeMode: $themeMode, audioPlayer: $audioPlayer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UiState &&
        other.themeMode == themeMode &&
        other.audioPlayer == audioPlayer;
  }

  @override
  int get hashCode => themeMode.hashCode ^ audioPlayer.hashCode;
}
