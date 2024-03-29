// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/action/app_db_actions.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/redux/redux_exception.dart';
import 'package:music_player/utils/app_db.dart';
import 'package:music_player/utils/yt_parser/lib/parser_helper.dart';

import '../../../redux/models/music_item.dart';
import '../../../utils/constants.dart';

/// when an music is over or [.seekNext(), .seekPrevious()] is fired
/// this stream will update the [MusicItem] for ui purposes.
///
StreamSubscription<int?>? _currentIndexStream;

class HandleAutomaticSeekAndPlay extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      _currentIndexStream =
          state.audioPlayerState.audioPlayer.currentIndexStream.listen((index) {
        if (index != null) {
          dispatch(
            SetSelectedMusicAction(
              selectedMusic:
                  state.audioPlayerState.currentMusicItemPlaylist[index],
            ),
          );
          dispatch(
            AddItemToRecentlyPlayedList(
              musicItem: state.audioPlayerState.currentMusicItemPlaylist[index],
            ),
          );
        }
      });
    } catch (err) {
      log('$err');
    }
  }
}

class SetSelectedMusicAction extends ReduxAction<AppState> {
  final MusicItem? selectedMusic;
  SetSelectedMusicAction({
    this.selectedMusic,
  });
  @override
  AppState reduce() {
    state.audioPlayerState.audioPlayer.playerState.processingState;
    return state.copyWith(
      audioPlayerState: state.audioPlayerState.copyWith(
        selectedMusic: selectedMusic,
      ),
    );
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

class _SetCurrentMusicItemPlaylist extends ReduxAction<AppState> {
  final List<MusicItem> musicItemList;
  _SetCurrentMusicItemPlaylist({
    required this.musicItemList,
  });

  @override
  AppState reduce() {
    return state.copyWith(
      audioPlayerState: state.audioPlayerState.copyWith(
        currentMusicItemPlaylist: musicItemList,
      ),
    );
  }
}

/// 0 - if the clicked music item is a part of the playlist, play that
/// instead of fetching.
/// 1 - fetch next music items from the currently requested music id
/// and make a list of [musicItem, ...fetchedMusicItem]
/// 2 - Fetch the current music item and play
/// 3 - Fetch and cache the urls
/// 4 - set the concatenating audio source
class PlayAudioAction extends ReduxAction<AppState> {
  final MusicItem musicItem;
  PlayAudioAction({
    required this.musicItem,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      if (state.audioPlayerState.selectedMusic?.musicId == musicItem.musicId) {
        return null;
      }

      /// check if the [musicItem] already in the playlist, then switch to that index
      final index = state.audioPlayerState.currentMusicItemPlaylist
          .indexWhere((element) => element.musicId == musicItem.musicId);
      if (index != -1) {
        state.audioPlayerState.audioPlayer.seek(Duration.zero, index: index);
        dispatch(
          SetSelectedMusicAction(
            selectedMusic:
                state.audioPlayerState.currentMusicItemPlaylist[index],
          ),
        );
        dispatch(
          AddItemToRecentlyPlayedList(
            musicItem: state.audioPlayerState.currentMusicItemPlaylist[index],
          ),
        );
        return null;
      }

      /// clean up and ui works
      dispatch(StopAudioAction());
      dispatch(SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.loading));
      // state.audioPlayerState.audioPlayer.dispose();
      dispatch(SetSelectedMusicAction(selectedMusic: musicItem));
      dispatch(AddItemToRecentlyPlayedList(musicItem: musicItem));
      _currentIndexStream?.cancel();

      /// Fetch and play the current music
      final uri = await ParserHelper.getMusicItemUrl(musicItem.musicId);
      await state.audioPlayerState.audioPlayer
          .setAudioSource(ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            uri,
            tag: musicItem.toMediaItem(),
          )
        ],
      ));
      dispatch(
        SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.idle,
        ),
      );
      state.audioPlayerState.audioPlayer.play();

      /// Fetch next music
      await dispatch(FetchNextMusicListFromMusicId(musicItem: musicItem));
      await dispatch(FetchAndBuildConcatenatingAudioSourceFromMusicItemList(
          musicItemList: state.audioPlayerState.currentMusicItemPlaylist));

      /// inserting from pos 1 as the 1st item already fetched and playing.
      (state.audioPlayerState.audioPlayer.audioSource
              as ConcatenatingAudioSource)
          .addAll(state.audioPlayerState.currentJustAudioPlaylist.children
              .sublist(1));
      dispatch(HandleAutomaticSeekAndPlay());
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      dispatch(SetSelectedMusicAction(selectedMusic: null));
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

class PlayPlaylistAction extends ReduxAction<AppState> {
  final List<MusicItem> musicItemList;
  final int index;
  PlayPlaylistAction({
    required this.musicItemList,
    this.index = 0,
  }) : assert(musicItemList.isNotEmpty);
  @override
  Future<AppState?> reduce() async {
    try {
      /// clean up and ui works
      dispatch(StopAudioAction());
      dispatch(SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.loading));
      // state.audioPlayerState.audioPlayer.dispose();
      dispatch(SetSelectedMusicAction(selectedMusic: musicItemList[index]));
      dispatch(AddItemToRecentlyPlayedList(musicItem: musicItemList[index]));
      _currentIndexStream?.cancel();

      /// Fetch and play the current music
      final uri =
          await ParserHelper.getMusicItemUrl(musicItemList[index].musicId);
      await state.audioPlayerState.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: [
            AudioSource.uri(
              uri,
              tag: musicItemList[index].toMediaItem(),
            )
          ],
        ),
      );
      dispatch(
        SetMusicItemMetaDataLoadingStateAction(
          loadingState: LoadingState.idle,
        ),
      );
      state.audioPlayerState.audioPlayer.play();
      await dispatch(
        FetchAndBuildConcatenatingAudioSourceFromMusicItemList(
          musicItemList: musicItemList,
        ),
      );

      dispatch(_SetCurrentMusicItemPlaylist(musicItemList: musicItemList));

      /// inserting from pos 1 as the 1st item already fetched and playing.
      (state.audioPlayerState.audioPlayer.audioSource
              as ConcatenatingAudioSource)
          .addAll(state.audioPlayerState.currentJustAudioPlaylist.children
              .sublist(1));
      dispatch(HandleAutomaticSeekAndPlay());
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      dispatch(SetSelectedMusicAction(selectedMusic: null));
      state.audioPlayerState.audioPlayer.stop();
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'PlayPlaylistAction',
        userErrorToastMessage: "Error loading music, try again!",
      );
    }
    return null;
  }
}

class SetMusicItemMetaDataLoadingStateAction extends ReduxAction<AppState> {
  final LoadingState loadingState;
  SetMusicItemMetaDataLoadingStateAction({
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
      dispatch(_SetCurrentMusicItemPlaylist(
          musicItemList: [musicItem, ...currentPlaylistItems]));
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
      Map<String, Uri> musicIdToUriMap = {};
      for (int i = 0; i < musicItemList.length; i++) {
        ParserHelper.getMusicItemUrl(musicItemList[i].musicId).then((uri) {
          cnt++;
          musicIdToUriMap[musicItemList[i].musicId] = uri;
          if (cnt == musicItemList.length) {
            controller.add(true);
          }
        });
      }
      await controller.stream.first;
      final audioPlaylist = ConcatenatingAudioSource(
        children: musicItemList
            .map(
              (e) => AudioSource.uri(
                musicIdToUriMap[e.musicId]!,
                tag: e.toMediaItem(),
              ),
            )
            .toList(),
      );
      dispatch(_SetConcatenatingAudioSource(playlist: audioPlaylist));
    } catch (err) {
      log('$err');
    }
  }
}
