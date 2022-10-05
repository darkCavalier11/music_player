// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/utils/app_db.dart';

class LoadUserPlaylistAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final playlistString = await AppDatabse.getQuery(DbKeys.playlistItem);
      if (playlistString == null) {
        return null;
      }
      final userPlaylistItems = (jsonDecode(playlistString) as List)
          .map((e) => UserPlaylistListItem.fromJson(e))
          .toList();
      return state.copyWith(
        userPlaylistState: state.userPlaylistState.copyWith(
          userPlaylistItems: userPlaylistItems,
        ),
      );
    } catch (err) {
      log(err.toString(), name: 'ErrorLog', stackTrace: StackTrace.current);
    }
    return null;
  }
}

// should be called after checking the playlist doesn't exist
class _CreateNewPlaylistWithMusicItem extends ReduxAction<AppState> {
  final MusicItem musicItem;
  final String playlistName;
  _CreateNewPlaylistWithMusicItem({
    required this.musicItem,
    required this.playlistName,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final playlistItems = [
        UserPlaylistListItem(
          id: '',
          title: playlistName,
          musicItems: [musicItem],
        ),
      ];
      await AppDatabse.setQuery(
        DbKeys.playlistItem,
        jsonEncode(playlistItems),
      );
    } catch (err) {
      log(
        err.toString(),
        name: 'ErrorLog',
        stackTrace: StackTrace.current,
      );
    }
    return null;
  }
}

class RemovePlaylistByName extends ReduxAction<AppState> {
  final String playlistName;
  RemovePlaylistByName({
    required this.playlistName,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final previousPlaylistsString =
          await AppDatabse.getQuery(DbKeys.playlistItem);
      final playListItems =
          (jsonDecode(previousPlaylistsString ?? '[]') as List)
              .map(
                (e) => UserPlaylistListItem.fromJson(e),
              )
              .toList();
      playListItems.removeWhere((element) => element.title == playlistName);
      await AppDatabse.setQuery(
        DbKeys.playlistItem,
        jsonEncode(
          playListItems.map((e) => e.toJson()).toList(),
        ),
      );
    } catch (err) {
      log(
        err.toString(),
        name: 'ErrorLog',
        stackTrace: StackTrace.current,
      );
    }
    return null;
  }
}

class AddMusicItemtoPlaylist extends ReduxAction<AppState> {
  final String playlistName;
  final MusicItem musicItem;
  AddMusicItemtoPlaylist({
    required this.playlistName,
    required this.musicItem,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final playlistsString = await AppDatabse.getQuery(DbKeys.playlistItem);
      if (playlistsString == null) {
        await dispatch(_CreateNewPlaylistWithMusicItem(
            musicItem: musicItem, playlistName: playlistName));
        return null;
      }
      final playListItems = (jsonDecode(playlistsString) as List)
          .map(
            (e) => UserPlaylistListItem.fromJson(e),
          )
          .toList();
      final playlistToAdd =
          playListItems.firstWhere((element) => element.title == playlistName);
      if (playlistToAdd.musicItems.contains(musicItem)) {
        return null;
      }
      playlistToAdd.musicItems.add(musicItem);
      await AppDatabse.setQuery(
        DbKeys.playlistItem,
        jsonEncode(
          playListItems.map((e) => e.toJson()).toList(),
        ),
      );
    } catch (err) {
      log(
        err.toString(),
        name: 'ErrorLog',
        stackTrace: StackTrace.current,
      );
    }
    return null;
  }

  @override
  void after() {
    dispatch(LoadUserPlaylistAction());
    super.after();
  }
}

class RemoveMusicItemFromPlaylist extends ReduxAction<AppState> {
  final String title;
  final MusicItem musicItem;
  RemoveMusicItemFromPlaylist({
    required this.title,
    required this.musicItem,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final playlistsString = await AppDatabse.getQuery(DbKeys.playlistItem);
      final playListItems = (jsonDecode(playlistsString ?? '[]') as List)
          .map(
            (e) => UserPlaylistListItem.fromJson(e),
          )
          .toList();
      final playlistToRemove =
          playListItems.firstWhere((element) => element.title == title);
      playlistToRemove.musicItems.remove(musicItem);
      // remove if no music left
      if (playlistToRemove.musicItems.isEmpty) {
        playListItems.remove(playlistToRemove);
      }
      await AppDatabse.setQuery(
        DbKeys.playlistItem,
        jsonEncode(
          playListItems.map((e) => e.toJson()).toList(),
        ),
      );
    } catch (err) {
      log(
        err.toString(),
        name: 'ErrorLog',
        stackTrace: StackTrace.current,
      );
    }
    return null;
  }

  @override
  void after() {
    dispatch(LoadUserPlaylistAction());

    super.after();
  }
}
