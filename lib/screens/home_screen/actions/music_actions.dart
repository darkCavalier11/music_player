// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/action/app_db_actions.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/redux/redux_exception.dart';
import 'package:music_player/utils/yt_parser/lib/parser_helper.dart';

import '../../../redux/models/music_item.dart';

// add callback to certain stream events from the musci player
class InitMusicPlayerAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    state.audioPlayerState.audioPlayer.currentIndexStream.listen((index) {
      if (index == null) {
        return;
      }
      // // * get the current music item that will be played

      // final currentMusicItem = MusicItem.fromMediaItem(state
      //     .audioPlayerState
      //     .currentJustAudioPlaylist
      //     .children[index]
      //     .sequence
      //     .first
      //     .tag as MediaItem);
      // dispatch(_SetMediaItemStateAction(selectedMusic: currentMusicItem));
      // dispatch(AddItemToRecentlyPlayedList(musicItem: currentMusicItem));
      // if (index ==
      //     state.audioPlayerState.currentJustAudioPlaylist.children.length - 1) {
      //   dispatch(GetNextMusicUrlAndAddToPlaylistAction());
      // }
    });
    return null;
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
      dispatch(_SetMediaItemStateAction(selectedMusic: musicItem));
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
        dispatch(
          _SetMusicItemMetaDataLoadingStateAction(
            loadingState: LoadingState.idle,
          ),
        );
        state.audioPlayerState.audioPlayer.play();
      }
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      dispatch(_SetMediaItemStateAction(selectedMusic: null));
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

// When the next button is clicked on UI or on the background this action
// currentPlaylistItems based on the current music item to be played and load the url
// for first music item in the currentPlaylistItems. This way new music item will be added
// to the current playlist and currentPlaylistItems will hold the suggestion for
// currently playing item.
class GetNextMusicUrlAndAddToPlaylistAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final currentMusicItem = state.audioPlayerState.selectedMusic;
      if (currentMusicItem == null) {
        return null;
      }
      await dispatch(FetchNextMusicListFromMusicId(musicItem: currentMusicItem));

      final nextMusicItem = state.audioPlayerState.currentPlaylistItems.first;
      final url = await ParserHelper.getMusicItemUrl(currentMusicItem.musicId);
      await state.audioPlayerState.currentJustAudioPlaylist
          .add(AudioSource.uri(url, tag: nextMusicItem.toMediaItem()));
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
    }
    return null;
  }
}
