import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/redux/models/audio_player_state.dart';

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
  final AudioPlayerState audioPlayerState;
  UiState({
    required this.audioPlayerState,
    required this.themeMode,
  });

  factory UiState.initial() {
    return UiState(
      themeMode: ThemeMode.light,
      audioPlayerState: AudioPlayerState.initial(),
    );
  }

  UiState copyWith({
    ThemeMode? themeMode,
    AudioPlayerState? audioPlayerState,
  }) {
    return UiState(
      themeMode: themeMode ?? this.themeMode,
      audioPlayerState: audioPlayerState ?? this.audioPlayerState,
    );
  }

  @override
  String toString() =>
      'UiState(themeMode: $themeMode, audioPlayer: $audioPlayerState)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UiState &&
        other.themeMode == themeMode &&
        other.audioPlayerState == audioPlayerState;
  }

  @override
  int get hashCode => themeMode.hashCode ^ audioPlayerState.hashCode;
}
