// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/audio_player_state.dart';
import 'package:music_player/redux/models/download_state.dart';
import 'package:music_player/redux/models/home_page_state.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/redux/models/user_playlist_state.dart';
import 'package:music_player/redux/models/user_profile_state.dart';

class AppState {
  final UserProfileState userProfileState;
  final UiState uiState;
  final AudioPlayerState audioPlayerState;
  final SearchState searchState;
  final HomePageState homePageState;
  final UserPlaylistState userPlaylistState;
  final DownloadState downloadState;
  AppState({
    required this.userProfileState,
    required this.uiState,
    required this.audioPlayerState,
    required this.searchState,
    required this.homePageState,
    required this.userPlaylistState,
    required this.downloadState,
  });

  AppState copyWith({
    UserProfileState? userProfileState,
    UiState? uiState,
    AudioPlayerState? audioPlayerState,
    SearchState? searchState,
    HomePageState? homePageState,
    UserPlaylistState? userPlaylistState,
    DownloadState? downloadState,
  }) {
    return AppState(
      userProfileState: userProfileState ?? this.userProfileState,
      uiState: uiState ?? this.uiState,
      audioPlayerState: audioPlayerState ?? this.audioPlayerState,
      searchState: searchState ?? this.searchState,
      homePageState: homePageState ?? this.homePageState,
      userPlaylistState: userPlaylistState ?? this.userPlaylistState,
      downloadState: downloadState ?? this.downloadState,
    );
  }

  factory AppState.initial() {
    return AppState(
      userProfileState: UserProfileState.initial(),
      uiState: UiState.initial(),
      audioPlayerState: AudioPlayerState.initial(),
      searchState: SearchState.initial(),
      homePageState: HomePageState.initial(),
      userPlaylistState: UserPlaylistState.initial(),
      downloadState: DownloadState.initial(),
    );
  }

  @override
  String toString() {
    return 'AppState(userProfileState: $userProfileState, uiState: $uiState, audioPlayerState: $audioPlayerState, searchState: $searchState, homePageState: $homePageState, userPlaylistState: $userPlaylistState, downloadState: $downloadState)';
  }

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.userProfileState == userProfileState &&
        other.uiState == uiState &&
        other.audioPlayerState == audioPlayerState &&
        other.searchState == searchState &&
        other.homePageState == homePageState &&
        other.userPlaylistState == userPlaylistState &&
        other.downloadState == downloadState;
  }

  @override
  int get hashCode {
    return userProfileState.hashCode ^
        uiState.hashCode ^
        audioPlayerState.hashCode ^
        searchState.hashCode ^
        homePageState.hashCode ^
        userPlaylistState.hashCode ^
        downloadState.hashCode;
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
