// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

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

class SetPlaylistAction extends ReduxAction<AppState> {
  final ConcatenatingAudioSource playlist;
  SetPlaylistAction({
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

/// It loads the url of the music item and the fetch next music items(not urls for each music item) based on this url if
/// a playlist not present already
/// the next item along with current item
/// are saved on the currentPlaylistItems.
/// Only the current music item and first one of the
/// currentPlaylistItems added to the current playlist.
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
      dispatch(StopAudioAction());
      dispatch(_SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.loading));
      dispatch(_SetSelectedMusicAction(selectedMusic: musicItem));
      dispatch(AddItemToRecentlyPlayedList(musicItem: musicItem));

      // * fetching music url
      final url = await ParserHelper.getMusicItemUrl(musicItem.musicId);

      // if the tapped music item is not a playlist item
      if (clearEarlierPlaylist == true) {
        // * fetch next list based on suggestions
        await dispatch(FetchNextMusicListFromMusicId(musicItem: musicItem));
        final _playlist = ConcatenatingAudioSource(
          children: [
            AudioSource.uri(
              url,
              tag: musicItem.toMediaItem(),
            ),
          ],
        );
        dispatch(SetPlaylistAction(playlist: _playlist));

        await state.audioPlayerState.audioPlayer
            .setAudioSource(state.audioPlayerState.currentJustAudioPlaylist);
        dispatch(
          _SetMusicItemMetaDataLoadingStateAction(
            loadingState: LoadingState.idle,
          ),
        );
        state.audioPlayerState.audioPlayer.play();
      } else {
        state.audioPlayerState.currentJustAudioPlaylist.add(
          AudioSource.uri(
            url,
            tag: musicItem.toMediaItem(),
          ),
        );

        /// playlist is holding the items those were previously played.
        /// When a new item is tapped on it will be added to the end and
        /// will be selected by index-1
        state.audioPlayerState.audioPlayer.seek(const Duration(seconds: 0),
            index: state.audioPlayerState.currentJustAudioPlaylist.length - 1);
        state.audioPlayerState.audioPlayer;
        dispatch(
          _SetMusicItemMetaDataLoadingStateAction(
            loadingState: LoadingState.idle,
          ),
        );
        state.audioPlayerState.audioPlayer.play();
      }
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
          currentPlaylistItems: [musicItem, ...currentPlaylistItems],
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

/// All music item are now a part of playlist, This action handles list of music item
/// playing them using `just_audio`
/// - Tapping on home screen music -> the entire music item list is the playlist
/// - Tapping on search screen music -> the entire search screen music
/// - Tapping on user playlist etc.
class PlayPlaylistAction extends ReduxAction<AppState> {
  final List<MusicItem> musicItemPlaylist;
  PlayPlaylistAction({
    required this.musicItemPlaylist,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      if (musicItemPlaylist.isEmpty) {
        return null;
      }
      dispatch(StopAudioAction());
      dispatch(_SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.loading));
      dispatch(_SetSelectedMusicAction(selectedMusic: musicItemPlaylist.first));
      dispatch(AddItemToRecentlyPlayedList(musicItem: musicItemPlaylist.first));

      // * fetching music url
      final url =
          await ParserHelper.getMusicItemUrl(musicItemPlaylist.first.musicId);
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      dispatch(_SetSelectedMusicAction(selectedMusic: null));
      state.audioPlayerState.audioPlayer.stop();
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'PlayPlaylistAction',
        userErrorToastMessage: "Error loading music, try again!",
      );
    }
  }
}
