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
  AudioPlayerState({
    required this.audioPlayer,
    this.selectedMusic,
    required this.nextMusicList,
  });

  factory AudioPlayerState.initial() {
    return AudioPlayerState(
      audioPlayer: AudioPlayer(),
      nextMusicList: [],
    );
  }

  AudioPlayerState copyWith({
    AudioPlayer? audioPlayer,
    MusicItem? selectedMusic,
    List<MusicItem>? nextMusicList,
  }) {
    return AudioPlayerState(
      audioPlayer: audioPlayer ?? this.audioPlayer,
      selectedMusic: selectedMusic ?? this.selectedMusic,
      nextMusicList: nextMusicList ?? this.nextMusicList,
    );
  }

  @override
  bool operator ==(covariant AudioPlayerState other) {
    if (identical(this, other)) return true;

    return other.audioPlayer == audioPlayer &&
        other.selectedMusic == selectedMusic &&
        listEquals(other.nextMusicList, nextMusicList);
  }

  @override
  int get hashCode =>
      audioPlayer.hashCode ^ selectedMusic.hashCode ^ nextMusicList.hashCode;

  @override
  String toString() =>
      'AudioPlayerState(audioPlayer: $audioPlayer, selectedMusic: $selectedMusic, nextMusicList: $nextMusicList)';
}

enum AudioPlayerStatus {
  idle,
  playing,
  loading,
  error,
}
