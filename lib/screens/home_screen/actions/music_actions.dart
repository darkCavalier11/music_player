// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:music_player/redux/action/app_db_actions.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/audio_player_state.dart';
import 'package:music_player/redux/models/music_filter_payload.dart';
import 'package:music_player/screens/home_screen/actions/home_screen_actions.dart';
import 'package:music_player/utils/api_request.dart';
import 'package:music_player/utils/app_db.dart';
import 'package:music_player/utils/url.dart';

import '../../../redux/models/music_item.dart';

// add callback to certain stream events from the musci player
class InitMusicPlayerAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    state.audioPlayerState.audioPlayer.currentIndexStream.listen((index) {
      if (index == null) {
        return null;
      }
      // * get the current music item that will be played

      final currentMusicItem = MusicItem.fromMediaItem(state
          .audioPlayerState.currentPlaylist.children[index].sequence.first.tag);
      dispatch(_SetMediaItemStateAction(selectedMusic: currentMusicItem));
      if (index == state.audioPlayerState.currentPlaylist.children.length - 1) {
        log('message');
        dispatch(GetNextMusicUrlAndAddToPlaylistAction());
      }
    });
  }
}

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

class SetPlaylistAction extends ReduxAction<AppState> {
  final ConcatenatingAudioSource playlist;
  SetPlaylistAction({
    required this.playlist,
  });

  @override
  AppState reduce() {
    return state.copyWith(
      audioPlayerState: state.audioPlayerState.copyWith(
        currentPlaylist: playlist,
      ),
    );
  }
}

// It loads the url of the music item and the fetch next music items(not urls) based on this url
// the next item are saved on the nextMusicList. Only the current music item and first one of the
// nextMusicList added to the current playlist.
class PlayAudioAction extends ReduxAction<AppState> {
  final MusicItem musicItem;
  PlayAudioAction({
    required this.musicItem,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      // * fetching music url
      await dispatch(_FetchMusicDetailsForSelectedMusicAction(
          selectedMusicItem: musicItem));

      await state.audioPlayerState.currentPlaylist.clear();
      final yt = YoutubeExplode();
      final manifest =
          await yt.videos.streamsClient.getManifest(musicItem.musicId);
      final url =
          manifest.audioOnly.firstWhere((element) => element.tag == 140).url;
      dispatch(_SetMediaItemStateAction(selectedMusic: musicItem));

      // * fetch next list based on suggestions
      await dispatch(FetchMusicListFromMusicId(musicItem: musicItem));

      final nextManifest = await yt.videos.streamsClient
          .getManifest(state.audioPlayerState.nextMusicList[0].musicId);
      final nextUrl = nextManifest.audioOnly
          .firstWhere((element) => element.tag == 140)
          .url;
      final _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          url,
          tag: musicItem.toMediaItem(),
        ),
        AudioSource.uri(
          nextUrl,
          tag: state.audioPlayerState.nextMusicList.first.toMediaItem(),
        ),
      ]);

      // * add item to local db
      dispatch(SetPlaylistAction(playlist: _playlist));
      dispatch(AddItemToRecentlyPlayedList(musicItem: musicItem));
      await state.audioPlayerState.audioPlayer
          .setAudioSource(state.audioPlayerState.currentPlaylist);

      await state.audioPlayerState.audioPlayer.play();
    } catch (err) {
      log(err.toString());
      Fluttertoast.showToast(msg: "Error loading music, try again!");
      dispatch(_SetMediaItemStateAction(selectedMusic: null));
      state.audioPlayerState.audioPlayer.stop();
    }
  }
}

// set the nextMusicList based on the current music item.
class FetchMusicListFromMusicId extends ReduxAction<AppState> {
  final MusicItem musicItem;
  FetchMusicListFromMusicId({
    required this.musicItem,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final serialisedString = await AppDatabse.getQuery(DbKeys.context);
      final musicFilterPayload =
          MusicFilterPayloadModel.fromJson(jsonDecode(serialisedString!));
      final res = await ApiRequest.post(
        AppUrl.nextMusicListUrl(musicFilterPayload.apiKey),
        {
          'context': musicFilterPayload.context.toJson(),
          'videoId': musicItem.musicId,
        },
      );
      if (res.statusCode == 200) {
        final nextMusicList = <MusicItem>[];

        final nextMusicListResponse = jsonDecode(res.data!)['contents']
                ['twoColumnWatchNextResults']['secondaryResults']
            ['secondaryResults']['results'] as List;
        for (var item in nextMusicListResponse) {
          if (item['compactVideoRenderer'] != null) {
            if (item['compactVideoRenderer']['videoId'] != null) {
              nextMusicList.add(MusicItem.fromApiJson(
                  item['compactVideoRenderer'],
                  parsingForMusicList: true));
            } else {
              // todo : handle playlist
            }
          }
        }
        return state.copyWith(
          audioPlayerState: state.audioPlayerState.copyWith(
            nextMusicList: nextMusicList,
          ),
        );
      }
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current);
    }
  }
}

class StopAudioAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    state.audioPlayerState.audioPlayer.stop();
  }
}

// dummy request for now update the client data to predict more accurate items
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
      final _ = await ApiRequest.post(
        AppUrl.playMusicUrl(musicPayload.apiKey),
        {
          'context': musicPayload.context.toJson(),
          'videoId': selectedMusicItem.musicId,
        },
      );
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current);
    }
  }
}

// When the next button is clicked on UI or on the background this action
// nextMusicList based on the current music item to be played and load the url
// for first music item in the nextMusicList. This way new music item will be added
// to the current playlist and nextMusicList will hold the suggestion for
// currently playing item.
class GetNextMusicUrlAndAddToPlaylistAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final currentMusicItem = state.audioPlayerState.selectedMusic;
      if (currentMusicItem == null) {
        return null;
      }
      await dispatch(FetchMusicListFromMusicId(musicItem: currentMusicItem));

      final nextMusicItem = state.audioPlayerState.nextMusicList.first;

      final yt = YoutubeExplode();

      final manifest =
          await yt.videos.streamsClient.getManifest(nextMusicItem.musicId);
      final url =
          manifest.audioOnly.firstWhere((element) => element.tag == 140).url;
      await state.audioPlayerState.currentPlaylist
          .add(AudioSource.uri(url, tag: nextMusicItem.toMediaItem()));
      dispatch(_FetchMusicDetailsForSelectedMusicAction(
          selectedMusicItem: currentMusicItem));
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current);
    }
  }
}
