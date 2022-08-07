import 'dart:async';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/audio_player_state.dart';

class _SetMediaItemStateAction extends ReduxAction<AppState> {
  final MediaItem? selectedMusic;
  _SetMediaItemStateAction({
    this.selectedMusic,
  });
  @override
  AppState reduce() {
    return state.copyWith(
        audioPlayerState: state.audioPlayerState.copyWith(
      selectedMusic: selectedMusic,
    ));
  }
}

class _SetAudioPlayerStatusAction extends ReduxAction<AppState> {
  final AudioPlayerStatus audioPlayerStatus;
  _SetAudioPlayerStatusAction({
    required this.audioPlayerStatus,
  });
  @override
  AppState reduce() {
    return state.copyWith(
        audioPlayerState: state.audioPlayerState.copyWith(
      audioPlayerStatus: audioPlayerStatus,
    ));
  }
}

class PlayAudioAction extends ReduxAction<AppState> {
  final MediaItem mediaItem;
  PlayAudioAction({
    required this.mediaItem,
  });
  @override
  Future<AppState?> reduce() async {
    dispatch(_SetMediaItemStateAction(selectedMusic: mediaItem));
    dispatch(_SetAudioPlayerStatusAction(
        audioPlayerStatus: AudioPlayerStatus.loading));
    try {
      final audioUri = AudioSource.uri(
        mediaItem.artUri ?? Uri(),
        tag: mediaItem,
      );
      await state.audioPlayerState.audioPlayer.setAudioSource(audioUri);
      dispatch(_SetAudioPlayerStatusAction(
          audioPlayerStatus: AudioPlayerStatus.playing));
      await state.audioPlayerState.audioPlayer.play();
    } catch (err) {
      // todo : log error
      Fluttertoast.showToast(msg: "Error loading music, try again!");
      log(err.toString());
      dispatch(_SetAudioPlayerStatusAction(
          audioPlayerStatus: AudioPlayerStatus.playing));
    }
  }
}

class StopAudioAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    state.audioPlayerState.audioPlayer.stop();
    dispatch(
        _SetAudioPlayerStatusAction(audioPlayerStatus: AudioPlayerStatus.idle));
  }
}
