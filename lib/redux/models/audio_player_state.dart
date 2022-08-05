import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/redux/models/music_model.dart';

class AudioPlayerState {
  final AudioPlayer audioPlayer;
  final MediaItem? selectedMusic;
  AudioPlayerState({
    required this.audioPlayer,
    this.selectedMusic,
  });

  factory AudioPlayerState.initial() {
    return AudioPlayerState(audioPlayer: AudioPlayer());
  }

  AudioPlayerState copyWith({
    AudioPlayer? audioPlayer,
    MediaItem? selectedMusic,
  }) {
    return AudioPlayerState(
      audioPlayer: audioPlayer ?? this.audioPlayer,
      selectedMusic: selectedMusic ?? this.selectedMusic,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AudioPlayerState &&
      other.audioPlayer == audioPlayer &&
      other.selectedMusic == selectedMusic;
  }

  @override
  int get hashCode => audioPlayer.hashCode ^ selectedMusic.hashCode;

  @override
  String toString() => 'AudioPlayerState(audioPlayer: $audioPlayer, selectedMusic: $selectedMusic)';
}
