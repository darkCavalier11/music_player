// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/redux/action/app_db_actions.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/redux/redux_exception.dart';
import 'package:music_player/utils/app_db.dart';
import 'package:music_player/utils/yt_parser/lib/parser_helper.dart';

import '../../../redux/models/music_item.dart';
import '../../../utils/constants.dart';

class _SetSelectedMusicAction extends ReduxAction<AppState> {
  final MusicItem? selectedMusic;
  _SetSelectedMusicAction({
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

class _SetConcatenatingAudioSource extends ReduxAction<AppState> {
  final ConcatenatingAudioSource playlist;
  _SetConcatenatingAudioSource({
    required this.playlist,
  });

  @override
  AppState reduce() {
    return state.copyWith(
      audioPlayerState: state.audioPlayerState.copyWith(
        currentJustAudioPlaylist: playlist,
      ),
    );
  }
}

/// 1 - fetch next music items from the currently requested music id
/// and make a list of [musicItem, ...fetchedMusicItem]
/// 2 - Fetch and cache the urls
/// 3 - set the concatenating audio source
class PlayAudioAction extends ReduxAction<AppState> {
  final MusicItem musicItem;
  // when tapping on a new music item this should be cleared and next set of music items need to be loaded
  final bool? clearEarlierPlaylist;
  PlayAudioAction({
    required this.musicItem,
    this.clearEarlierPlaylist,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      /// clean up and ui works
      dispatch(StopAudioAction());
      dispatch(_SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.loading));
      dispatch(_SetSelectedMusicAction(selectedMusic: musicItem));
      dispatch(AddItemToRecentlyPlayedList(musicItem: musicItem));

      /// Fetch next music
      await dispatch(FetchNextMusicListFromMusicId(musicItem: musicItem));
      FetchAndBuildConcatenatingAudioSourceFromMusicItemList(
          musicItemList: state.audioPlayerState.currentMusicItemPlaylist);

      /// set audio source and play
      await state.audioPlayerState.audioPlayer
          .setAudioSource(state.audioPlayerState.currentJustAudioPlaylist);
      await state.audioPlayerState.audioPlayer.play();
      dispatch(
        _SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.idle,
        ),
      );
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      dispatch(_SetSelectedMusicAction(selectedMusic: null));
      state.audioPlayerState.audioPlayer.stop();
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'PlayAudioAction',
        userErrorToastMessage: "Error loading music, try again!",
      );
    }
    return null;
  }
}

class _SetMusicItemMetaDataLoadingStateAction extends ReduxAction<AppState> {
  final LoadingState loadingState;
  _SetMusicItemMetaDataLoadingStateAction({
    required this.loadingState,
  });
  @override
  AppState reduce() {
    return state.copyWith(
      audioPlayerState: state.audioPlayerState.copyWith(
        musicItemMetaDataLoadingState: loadingState,
      ),
    );
  }
}

/// set the currentPlaylistItems based on the current music item.
class FetchNextMusicListFromMusicId extends ReduxAction<AppState> {
  final MusicItem musicItem;
  FetchNextMusicListFromMusicId({
    required this.musicItem,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final currentPlaylistItems =
          await ParserHelper.getNextSuggestionMusicList(musicItem.musicId);
      return state.copyWith(
        audioPlayerState: state.audioPlayerState.copyWith(
          currentMusicItemPlaylist: [musicItem, ...currentPlaylistItems],
        ),
      );
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'FetchNextMusicListFromMusicId',
      );
    }
  }
}

class StopAudioAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    state.audioPlayerState.audioPlayer.stop();
    return null;
  }
}

class AddMusicItemToRecentlyTapMusicItem extends ReduxAction<AppState> {
  final MusicItem musicItem;
  AddMusicItemToRecentlyTapMusicItem({required this.musicItem});
  @override
  Future<AppState?> reduce() async {
    try {
      final recentlyTappedString =
          await AppDatabase.getQuery(DbKeys.recentlyTappedMusicItem);
      var recentlyTappedMusicItems =
          (jsonDecode(recentlyTappedString ?? '[]') as List)
              .map((e) => MusicItem.fromJson(e))
              .toList();
      if (recentlyTappedMusicItems
              .indexWhere((element) => element.musicId == musicItem.musicId) !=
          -1) {
        return null;
      }
      recentlyTappedMusicItems.insert(0, musicItem);
      if (recentlyTappedMusicItems.length > 5) {
        recentlyTappedMusicItems.removeLast();
      }
      await AppDatabase.setQuery(
          DbKeys.recentlyTappedMusicItem, jsonEncode(recentlyTappedMusicItems));

      return state.copyWith(
        searchState: state.searchState.copyWith(
          recentlyTappedMusicItems: recentlyTappedMusicItems,
        ),
      );
    } catch (err) {
      log('$err', stackTrace: StackTrace.current);
    }
  }
}

/// Handles playing a playlist.
class PlayMusicItemPlaylistAction extends ReduxAction<AppState> {
  final List<MusicItem> musicItemList;

  /// the index of the musicItemList that requested to be played. [default=0]
  final int index;
  PlayMusicItemPlaylistAction({
    required this.musicItemList,
    this.index = 0,
  }) : assert(index >= 0 && index < musicItemList.length);
  @override
  Future<AppState?> reduce() async {
    try {
      dispatch(StopAudioAction());
      dispatch(_SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.loading));
      dispatch(_SetSelectedMusicAction(selectedMusic: musicItemList[index]));
      dispatch(AddItemToRecentlyPlayedList(musicItem: musicItemList[index]));
      dispatch(FetchAndBuildConcatenatingAudioSourceFromMusicItemList(
          musicItemList: musicItemList));

      await state.audioPlayerState.audioPlayer
          .setAudioSource(state.audioPlayerState.currentJustAudioPlaylist);
      dispatch(
        _SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.idle,
        ),
      );
      state.audioPlayerState.audioPlayer.play();
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      dispatch(_SetSelectedMusicAction(selectedMusic: null));
      state.audioPlayerState.audioPlayer.stop();
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'PlayMusicItemPlaylistAction',
        userErrorToastMessage: "Error loading music, try again!",
      );
    }
  }
}

class FetchAndBuildConcatenatingAudioSourceFromMusicItemList
    extends ReduxAction<AppState> {
  final List<MusicItem> musicItemList;
  FetchAndBuildConcatenatingAudioSourceFromMusicItemList({
    required this.musicItemList,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final controller = StreamController<bool>();
      int cnt = 0;
      List<Uri> musicListUris = List.generate(
        musicItemList.length,
        (index) => Uri(),
      );
      for (int i = 0; i < musicItemList.length; i++) {
        ParserHelper.getMusicItemUrl(musicItemList[i].musicId).then((uri) {
          cnt++;
          musicListUris[i] = uri;
          if (cnt == musicItemList.length) {
            controller.add(true);
          }
        });
      }
      await controller.stream.first;
      final audioPlaylist = ConcatenatingAudioSource(
        children: musicListUris.map((e) => AudioSource.uri(e)).toList(),
      );
      dispatch(_SetConcatenatingAudioSource(playlist: audioPlaylist));
    } catch (err) {
      log('$err');
    }
  }
}
