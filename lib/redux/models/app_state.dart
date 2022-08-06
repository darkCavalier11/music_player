import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/redux/models/audio_player_state.dart';

class AppState {
  final UiState uiState;
  final AudioPlayerState audioPlayerState;
  AppState({
    required this.uiState,
    required this.audioPlayerState,
  });

  AppState copyWith({
    UiState? uiState,
    AudioPlayerState? audioPlayerState,
  }) {
    return AppState(
      uiState: uiState ?? this.uiState,
      audioPlayerState: audioPlayerState ?? this.audioPlayerState,
    );
  }

  factory AppState.initial() {
    return AppState(
      uiState: UiState.initial(),
      audioPlayerState: AudioPlayerState.initial(),
    );
  }

  @override
  String toString() => 'AppState(uiState: $uiState, audioPlayerState: $audioPlayerState)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppState &&
      other.uiState == uiState &&
      other.audioPlayerState == audioPlayerState;
  }

  @override
  int get hashCode => uiState.hashCode ^ audioPlayerState.hashCode;
}

class UiState {
  final ThemeMode themeMode;
  UiState({
    required this.themeMode,
  });

  factory UiState.initial() {
    return UiState(
      themeMode: ThemeMode.light,
    );
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
  
    return other is UiState &&
      other.themeMode == themeMode;
  }

  @override
  int get hashCode => themeMode.hashCode;
}
