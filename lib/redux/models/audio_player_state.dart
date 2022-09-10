// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/music_model.dart';

class AudioPlayerState {
  final AudioPlayer audioPlayer;
  final MusicItem? selectedMusic;
  final List<MusicItem> nextMusicList;
  final ConcatenatingAudioSource currentPlaylist;
  AudioPlayerState({
    required this.audioPlayer,
    this.selectedMusic,
    required this.nextMusicList,
    required this.currentPlaylist,
  });

  factory AudioPlayerState.initial() {
    return AudioPlayerState(
      audioPlayer: AudioPlayer(),
      nextMusicList: [],
      currentPlaylist: ConcatenatingAudioSource(children: []),
    );
  }

  AudioPlayerState copyWith({
    AudioPlayer? audioPlayer,
    MusicItem? selectedMusic,
    List<MusicItem>? nextMusicList,
    ConcatenatingAudioSource? currentPlaylist,
  }) {
    return AudioPlayerState(
      audioPlayer: audioPlayer ?? this.audioPlayer,
      selectedMusic: selectedMusic ?? this.selectedMusic,
      nextMusicList: nextMusicList ?? this.nextMusicList,
      currentPlaylist: currentPlaylist ?? this.currentPlaylist,
    );
  }

  @override
  bool operator ==(covariant AudioPlayerState other) {
    if (identical(this, other)) return true;

    return other.audioPlayer == audioPlayer &&
        other.selectedMusic == selectedMusic &&
        listEquals(other.nextMusicList, nextMusicList) &&
        other.currentPlaylist == currentPlaylist;
  }

  @override
  int get hashCode {
    return audioPlayer.hashCode ^
        selectedMusic.hashCode ^
        nextMusicList.hashCode ^
        currentPlaylist.hashCode;
  }

  @override
  String toString() {
    return 'AudioPlayerState(audioPlayer: $audioPlayer, selectedMusic: $selectedMusic, nextMusicList: $nextMusicList, currentPlaylist: $currentPlaylist)';
  }
}

enum AudioPlayerStatus {
  idle,
  playing,
  loading,
  error,
}
