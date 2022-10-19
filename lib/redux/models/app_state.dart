// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/audio_player_state.dart';
import 'package:music_player/redux/models/home_page_state.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/redux/models/user_playlist_state.dart';

class AppState {
  final UiState uiState;
  final AudioPlayerState audioPlayerState;
  final SearchState searchState;
  final HomePageState homePageState;
  final UserPlaylistState userPlaylistState;
  AppState({
    required this.uiState,
    required this.audioPlayerState,
    required this.searchState,
    required this.homePageState,
    required this.userPlaylistState,
  });

  AppState copyWith({
    UiState? uiState,
    AudioPlayerState? audioPlayerState,
    SearchState? searchState,
    HomePageState? homePageState,
    UserPlaylistState? userPlaylistState,
  }) {
    return AppState(
      uiState: uiState ?? this.uiState,
      audioPlayerState: audioPlayerState ?? this.audioPlayerState,
      searchState: searchState ?? this.searchState,
      homePageState: homePageState ?? this.homePageState,
      userPlaylistState: userPlaylistState ?? this.userPlaylistState,
    );
  }

  factory AppState.initial() {
    return AppState(
      uiState: UiState.initial(),
      audioPlayerState: AudioPlayerState.initial(),
      searchState: SearchState.initial(),
      homePageState: HomePageState.initial(),
      userPlaylistState: UserPlaylistState.initial(),
    );
  }

  @override
  String toString() {
    return 'AppState(uiState: $uiState, audioPlayerState: $audioPlayerState, searchState: $searchState, homePageState: $homePageState, userPlaylistState: $userPlaylistState)';
  }

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.uiState == uiState &&
        other.audioPlayerState == audioPlayerState &&
        other.searchState == searchState &&
        other.homePageState == homePageState &&
        other.userPlaylistState == userPlaylistState;
  }

  @override
  int get hashCode {
    return uiState.hashCode ^
        audioPlayerState.hashCode ^
        searchState.hashCode ^
        homePageState.hashCode ^
        userPlaylistState.hashCode;
  }
}

class UiState {
  final ThemeMode themeMode;
  final int currentBottomNavIndex;
  // When tap on a music tile the current screen scales down and music tile
  // pops to give a subtle animation. When a music is tapped long this set to true and
  // scale animation started and when finshed set to true.
  final bool isMusicSelectedScreenActive;
  UiState({
    required this.themeMode,
    required this.currentBottomNavIndex,
    required this.isMusicSelectedScreenActive,
  });

  factory UiState.initial() {
    return UiState(
      themeMode: ThemeMode.light,
      currentBottomNavIndex: 0,
      isMusicSelectedScreenActive: false,
    );
  }

  UiState copyWith({
    ThemeMode? themeMode,
    int? currentBottomNavIndex,
    bool? isMusicSelectedScreenActive,
  }) {
    return UiState(
      themeMode: themeMode ?? this.themeMode,
      currentBottomNavIndex:
          currentBottomNavIndex ?? this.currentBottomNavIndex,
      isMusicSelectedScreenActive:
          isMusicSelectedScreenActive ?? this.isMusicSelectedScreenActive,
    );
  }

  @override
  String toString() =>
      'UiState(themeMode: $themeMode, currentBottomNavIndex: $currentBottomNavIndex, isMusicSelectedScreenActive: $isMusicSelectedScreenActive)';

  @override
  bool operator ==(covariant UiState other) {
    if (identical(this, other)) return true;

    return other.themeMode == themeMode &&
        other.currentBottomNavIndex == currentBottomNavIndex &&
        other.isMusicSelectedScreenActive == isMusicSelectedScreenActive;
  }

  @override
  int get hashCode =>
      themeMode.hashCode ^
      currentBottomNavIndex.hashCode ^
      isMusicSelectedScreenActive.hashCode;
}
