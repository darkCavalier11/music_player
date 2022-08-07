import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/music_model.dart';

class AudioPlayerState {
  final AudioPlayer audioPlayer;
  final MediaItem? selectedMusic;
  final AudioPlayerStatus audioPlayerStatus;
  AudioPlayerState({
    required this.audioPlayer,
    this.selectedMusic,
    required this.audioPlayerStatus,
  });

  factory AudioPlayerState.initial() {
    return AudioPlayerState(audioPlayer: AudioPlayer(), audioPlayerStatus: AudioPlayerStatus.idle);
  }

  AudioPlayerState copyWith({
    AudioPlayer? audioPlayer,
    MediaItem? selectedMusic,
    AudioPlayerStatus? audioPlayerStatus,
  }) {
    return AudioPlayerState(
      audioPlayer: audioPlayer ?? this.audioPlayer,
      selectedMusic: selectedMusic ?? this.selectedMusic,
      audioPlayerStatus: audioPlayerStatus ?? this.audioPlayerStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AudioPlayerState &&
      other.audioPlayer == audioPlayer &&
      other.selectedMusic == selectedMusic &&
      other.audioPlayerStatus == audioPlayerStatus;
  }

  @override
  int get hashCode => audioPlayer.hashCode ^ selectedMusic.hashCode ^ audioPlayerStatus.hashCode;

  @override
  String toString() => 'AudioPlayerState(audioPlayer: $audioPlayer, selectedMusic: $selectedMusic, audioPlayerStatus: $audioPlayerStatus)';
}


enum AudioPlayerStatus {
  idle,
  playing,
  loading,
  error,
}