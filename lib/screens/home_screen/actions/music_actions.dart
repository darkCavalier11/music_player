// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/audio_player_state.dart';
import 'package:music_player/redux/models/music_filter_payload.dart';
import 'package:music_player/screens/home_screen/actions/home_screen_actions.dart';
import 'package:music_player/utils/api_request.dart';
import 'package:music_player/utils/app_db.dart';
import 'package:music_player/utils/url.dart';

import '../../../redux/models/music_item.dart';

class _SetMediaItemStateAction extends ReduxAction<AppState> {
  final MusicItem? selectedMusic;
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

class PlayAudioAction extends ReduxAction<AppState> {
  final MusicItem mediaItem;
  PlayAudioAction({
    required this.mediaItem,
  });
  @override
  Future<AppState?> reduce() async {
    dispatch(_SetMediaItemStateAction(selectedMusic: mediaItem));
    try {
      await dispatch(_FetchMusicDetailsForSelectedMusicAction(
          selectedMusicItem: mediaItem));
      final audioUri = AudioSource.uri(
        Uri.parse(state.audioPlayerState.selectedMusic?.musicUrl ?? ''),
        tag: mediaItem.toMediaItem(),
      );
      await state.audioPlayerState.audioPlayer.setAudioSource(audioUri);
      await state.audioPlayerState.audioPlayer.play();
    } catch (err) {
      Fluttertoast.showToast(msg: "Error loading music, try again!");
      dispatch(_SetMediaItemStateAction(selectedMusic: null));
      state.audioPlayerState.audioPlayer.stop();
    }
  }
}

class StopAudioAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    state.audioPlayerState.audioPlayer.stop();
  }
}

class _FetchMusicDetailsForSelectedMusicAction extends ReduxAction<AppState> {
  final MusicItem selectedMusicItem;
  _FetchMusicDetailsForSelectedMusicAction({
    required this.selectedMusicItem,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      String? musicPayloadString = await AppDatabse.getQuery(DbKeys.context);

      if (musicPayloadString == null) {
        dispatch(LoadHomePageMusicAction());
      }
      musicPayloadString = await AppDatabse.getQuery(DbKeys.context);
      if (musicPayloadString == null) {
        Fluttertoast.showToast(msg: 'Error getting music item.');
        return null;
      }
      final musicPayload =
          MusicFilterPayloadModel.fromJson(jsonDecode(musicPayloadString));
      final res = await ApiRequest.post(
        AppUrl.playMusicUrl(musicPayload.apiKey),
        {
          'context': musicPayload.context.toJson(),
          'videoId': selectedMusicItem.videoId,
        },
      );
      if (res.statusCode == 200) {
        final selectedMusicData = jsonDecode(res.data!);
        final formatList =
            selectedMusicData['streamingData']['adaptiveFormats'] as List;

        for (var musicFormatItem in formatList) {
          if (musicFormatItem['itag'] == 140) {
            return state.copyWith(
              audioPlayerState: state.audioPlayerState.copyWith(
                selectedMusic: state.audioPlayerState.selectedMusic?.copyWith(
                  musicUrl: musicFormatItem['url'],
                ),
              ),
            );
          }
        }
      }
      Fluttertoast.showToast(msg: 'Error getting music item');
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current);
    }
  }
}
