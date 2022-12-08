// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/redux/redux_exception.dart';
import 'package:music_player/utils/app_db.dart';
import 'package:uuid/uuid.dart';

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
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'LoadUserPlaylistAction',
        userErrorToastMessage: 'Unable to get your playlist!',
      );
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
      final existedPlaylistItems =
          (jsonDecode(await AppDatabse.getQuery(DbKeys.playlistItem) ?? '[]')
                  as List)
              .map((e) => UserPlaylistListItem.fromJson(e))
              .toList();
      existedPlaylistItems.add(UserPlaylistListItem(
        id: const Uuid().v4(),
        title: playlistName,
        musicItems: [musicItem],
      ));

      await AppDatabse.setQuery(
        DbKeys.playlistItem,
        jsonEncode(existedPlaylistItems),
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

class RemovePlaylistById extends ReduxAction<AppState> {
  final String playlistId;
  RemovePlaylistById({
    required this.playlistId,
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
      playListItems.removeWhere((element) => element.id == playlistId);
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
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'RemovePlaylistById',
        userErrorToastMessage: 'Unable to remove playlist!',
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
      final _playlistIndex =
          playListItems.indexWhere((element) => element.title == playlistName);
      if (_playlistIndex == -1) {
        dispatch(_CreateNewPlaylistWithMusicItem(
            musicItem: musicItem, playlistName: playlistName));
        return null;
      }
      final playlistToAdd = playListItems[_playlistIndex];
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
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'AddMusicItemtoPlaylist',
        userErrorToastMessage: 'Unable to add item to playlist!',
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
          playListItems .firstWhere((element) => element.title == title);
      playlistToRemove.musicItems
          .removeWhere((e) => e.musicId == musicItem.musicId);
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
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'RemoveMusicItemFromPlaylist',
        userErrorToastMessage: 'Unable to remove item from playlist!',
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
