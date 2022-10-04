// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/audio_player_state.dart';
import 'package:music_player/redux/models/home_page_state.dart';
import 'package:music_player/redux/models/search_state.dart';

class AppState {
  final UiState uiState;
  final AudioPlayerState audioPlayerState;
  final SearchState searchState;
  final HomePageState homePageState;
  AppState({
    required this.uiState,
    required this.audioPlayerState,
    required this.searchState,
    required this.homePageState,
  });

  AppState copyWith({
    UiState? uiState,
    AudioPlayerState? audioPlayerState,
    SearchState? searchState,
    HomePageState? homePageState,
  }) {
    return AppState(
      uiState: uiState ?? this.uiState,
      audioPlayerState: audioPlayerState ?? this.audioPlayerState,
      searchState: searchState ?? this.searchState,
      homePageState: homePageState ?? this.homePageState,
    );
  }

  factory AppState.initial() {
    return AppState(
      uiState: UiState.initial(),
      audioPlayerState: AudioPlayerState.initial(),
      searchState: SearchState.initial(),
      homePageState: HomePageState.initial(),
    );
  }

  @override
  String toString() {
    return 'AppState(uiState: $uiState, audioPlayerState: $audioPlayerState, searchState: $searchState, homePageState: $homePageState)';
  }

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.uiState == uiState &&
        other.audioPlayerState == audioPlayerState &&
        other.searchState == searchState &&
        other.homePageState == homePageState;
  }

  @override
  int get hashCode {
    return uiState.hashCode ^
        audioPlayerState.hashCode ^
        searchState.hashCode ^
        homePageState.hashCode;
  }
}

class UiState {
  final ThemeMode themeMode;
  final int currentBottomNavIndex;
  UiState({
    required this.themeMode,
    required this.currentBottomNavIndex,
  });

  factory UiState.initial() {
    return UiState(
      themeMode: ThemeMode.light,
      currentBottomNavIndex: 0,
    );
  }

  UiState copyWith({
    ThemeMode? themeMode,
    int? currentBottomNavIndex,
  }) {
    return UiState(
      themeMode: themeMode ?? this.themeMode,
      currentBottomNavIndex:
          currentBottomNavIndex ?? this.currentBottomNavIndex,
    );
  }

  @override
  String toString() =>
      'UiState(themeMode: $themeMode, currentBottomNavIndex: $currentBottomNavIndex)';

  @override
  bool operator ==(covariant UiState other) {
    if (identical(this, other)) return true;

    return other.themeMode == themeMode &&
        other.currentBottomNavIndex == currentBottomNavIndex;
  }

  @override
  int get hashCode => themeMode.hashCode ^ currentBottomNavIndex.hashCode;
}
