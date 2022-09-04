// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/music_model.dart';

class AudioPlayerState {
  final AudioPlayer audioPlayer;
  final MusicItem? selectedMusic;
  AudioPlayerState({
    required this.audioPlayer,
    this.selectedMusic,
  });

  factory AudioPlayerState.initial() {
    return AudioPlayerState(
      audioPlayer: AudioPlayer(),
    );
  }

  AudioPlayerState copyWith({
    AudioPlayer? audioPlayer,
    MusicItem? selectedMusic,
  }) {
    return AudioPlayerState(
      audioPlayer: audioPlayer ?? this.audioPlayer,
      selectedMusic: selectedMusic ?? this.selectedMusic,
    );
  }

  @override
  bool operator ==(covariant AudioPlayerState other) {
    if (identical(this, other)) return true;

    return other.audioPlayer == audioPlayer &&
        other.selectedMusic == selectedMusic;
  }

  @override
  int get hashCode => audioPlayer.hashCode ^ selectedMusic.hashCode;

  @override
  String toString() =>
      'AudioPlayerState(audioPlayer: $audioPlayer, selectedMusic: $selectedMusic)';
}

enum AudioPlayerStatus {
  idle,
  playing,
  loading,
  error,
}
