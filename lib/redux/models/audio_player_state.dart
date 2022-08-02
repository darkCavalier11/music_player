import 'package:just_audio/just_audio.dart';

class AudioPlayerState {
  final AudioPlayer audioPlayer;
  final String? selectedMusicUrl;
  AudioPlayerState({
    required this.audioPlayer,
    this.selectedMusicUrl,
  });

  factory AudioPlayerState.initial() {
    return AudioPlayerState(audioPlayer: AudioPlayer());
  }

  AudioPlayerState copyWith({
    AudioPlayer? audioPlayer,
    String? selectedMusicUrl,
  }) {
    return AudioPlayerState(
      audioPlayer: audioPlayer ?? this.audioPlayer,
      selectedMusicUrl: selectedMusicUrl ?? this.selectedMusicUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AudioPlayerState &&
      other.audioPlayer == audioPlayer &&
      other.selectedMusicUrl == selectedMusicUrl;
  }

  @override
  int get hashCode => audioPlayer.hashCode ^ selectedMusicUrl.hashCode;

  @override
  String toString() => 'AudioPlayerState(audioPlayer: $audioPlayer, selectedMusicUrl: $selectedMusicUrl)';
}
