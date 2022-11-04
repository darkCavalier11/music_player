// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/search_state.dart';

class AudioPlayerState {
  final AudioPlayer audioPlayer;
  final MusicItem? selectedMusic;
  final List<MusicItem> currentPlaylistItems;
  final ConcatenatingAudioSource currentJustAudioPlaylist;
  // This loading state is required to keep track when the music item actually fetching the
  // music url. In that time this chages to loading and enhances the feedback for the user.
  final LoadingState musicItemMetaDataLoadingState;
  AudioPlayerState({
    required this.audioPlayer,
    this.selectedMusic,
    required this.currentPlaylistItems,
    required this.currentJustAudioPlaylist,
    required this.musicItemMetaDataLoadingState,
  });

  factory AudioPlayerState.initial() {
    return AudioPlayerState(
      audioPlayer: AudioPlayer(),
      currentPlaylistItems: [],
      currentJustAudioPlaylist: ConcatenatingAudioSource(children: []),
      musicItemMetaDataLoadingState: LoadingState.idle,
    );
  }

  AudioPlayerState copyWith({
    AudioPlayer? audioPlayer,
    MusicItem? selectedMusic,
    List<MusicItem>? currentPlaylistItems,
    ConcatenatingAudioSource? currentJustAudioPlaylist,
    LoadingState? musicItemMetaDataLoadingState,
  }) {
    return AudioPlayerState(
      audioPlayer: audioPlayer ?? this.audioPlayer,
      selectedMusic: selectedMusic ?? this.selectedMusic,
      currentPlaylistItems: currentPlaylistItems ?? this.currentPlaylistItems,
      currentJustAudioPlaylist: currentJustAudioPlaylist ?? this.currentJustAudioPlaylist,
      musicItemMetaDataLoadingState:
          musicItemMetaDataLoadingState ?? this.musicItemMetaDataLoadingState,
    );
  }

  @override
  bool operator ==(covariant AudioPlayerState other) {
    if (identical(this, other)) return true;

    return other.audioPlayer == audioPlayer &&
        other.selectedMusic == selectedMusic &&
        listEquals(other.currentPlaylistItems, currentPlaylistItems) &&
        other.currentJustAudioPlaylist == currentJustAudioPlaylist &&
        other.musicItemMetaDataLoadingState == musicItemMetaDataLoadingState;
  }

  @override
  int get hashCode {
    return audioPlayer.hashCode ^
        selectedMusic.hashCode ^
        currentPlaylistItems.hashCode ^
        currentJustAudioPlaylist.hashCode ^
        musicItemMetaDataLoadingState.hashCode;
  }

  @override
  String toString() {
    return 'AudioPlayerState(audioPlayer: $audioPlayer, selectedMusic: $selectedMusic, currentPlaylistItems: $currentPlaylistItems, currentJustAudioPlaylist: $currentJustAudioPlaylist, musicItemMetaDataLoadingState: $musicItemMetaDataLoadingState)';
  }
}

enum AudioPlayerStatus {
  idle,
  playing,
  loading,
  error,
}
