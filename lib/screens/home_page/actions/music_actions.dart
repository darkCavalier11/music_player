import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/app_state.dart';

class SetMediaItemStateAction extends ReduxAction<AppState> {
  final MediaItem? selectedMusic;
  SetMediaItemStateAction({
    this.selectedMusic,
  });
  @override
  AppState reduce() {
    return state.copyWith(
      audioPlayerState: state.audioPlayerState.copyWith(
        selectedMusic: selectedMusic,
      )
    );
  }
}
