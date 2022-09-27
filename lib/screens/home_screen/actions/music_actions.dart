// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/utils/yt_parser/lib/parser_helper.dart';

import 'package:music_player/redux/action/app_db_actions.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../redux/models/music_item.dart';

// add callback to certain stream events from the musci player
class InitMusicPlayerAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    state.audioPlayerState.audioPlayer.currentIndexStream.listen((index) {
      if (index == null) {
        return;
      }
      // * get the current music item that will be played

      final currentMusicItem = MusicItem.fromMediaItem(state.audioPlayerState
          .currentPlaylist.children[index].sequence.first.tag as MediaItem);
      dispatch(_SetMediaItemStateAction(selectedMusic: currentMusicItem));
      if (index == state.audioPlayerState.currentPlaylist.children.length - 1) {
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
      dispatch(StopAudioAction());
      // * fetching music url

      await state.audioPlayerState.currentPlaylist.clear();
      final url = await ParserHelper.getMusicItemUrl(musicItem.musicId);

      // * fetch next list based on suggestions
      await dispatch(FetchMusicListFromMusicId(musicItem: musicItem));

      dispatch(_SetMediaItemStateAction(selectedMusic: musicItem));

      final _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          url,
          tag: musicItem.toMediaItem(),
        ),
      ]);

      // * add item to local db

      dispatch(SetPlaylistAction(playlist: _playlist));
      dispatch(AddItemToRecentlyPlayedList(musicItem: musicItem));
      await state.audioPlayerState.audioPlayer
          .setAudioSource(state.audioPlayerState.currentPlaylist);

      final nextUrl = await ParserHelper.getMusicItemUrl(
          state.audioPlayerState.nextMusicList[0].musicId);
      _playlist.add(
        AudioSource.uri(
          nextUrl,
          tag: state.audioPlayerState.nextMusicList.first.toMediaItem(),
        ),
      );

      await state.audioPlayerState.audioPlayer.play();
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
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
      final nextMusicList =
          await ParserHelper.getNextSuggestionMusicList(musicItem.musicId);
      return state.copyWith(
        audioPlayerState: state.audioPlayerState.copyWith(
          nextMusicList: nextMusicList,
        ),
      );
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
    }
  }
}

class StopAudioAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    state.audioPlayerState.audioPlayer.stop();
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
      final url = await ParserHelper.getMusicItemUrl(currentMusicItem.musicId);
      await state.audioPlayerState.currentPlaylist
          .add(AudioSource.uri(url, tag: nextMusicItem.toMediaItem()));
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
    }
  }
}
