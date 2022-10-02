// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:uuid/uuid.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/utils/app_db.dart';

// Called after checking the playlist doesn't exist
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
      final previousPlaylistsString =
          await AppDatabse.getQuery(DbKeys.playlistItem);
      await AppDatabse.setQuery(
        DbKeys.playlistItem,
        jsonEncode(
          [
            ...jsonDecode(previousPlaylistsString ?? '[]'),
          ],
        ),
      );
    } catch (err) {
      log(
        err.toString(),
        name: 'ErrorLog',
        stackTrace: StackTrace.current,
      );
    }
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
        await dispatch(_CreateNewPlaylistWithMusicItem(musicItem: musicItem, playlistName: playlistName));
        return null;
      }
      final playListItems = (jsonDecode(playlistsString) as List)
          .map(
            (e) => UserPlaylistListItem.fromJson(e),
          )
          .toList();
      final playlistToAdd =
          playListItems.firstWhere((element) => element.title == playlistName);
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
  }
}

class RemoveMusicItemFromPlaylist extends ReduxAction<AppState> {
  final String id;
  final MusicItem musicItem;
  RemoveMusicItemFromPlaylist({
    required this.id,
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
      final playlistToAdd =
          playListItems.firstWhere((element) => element.id == id);
      playlistToAdd.musicItems.remove(musicItem);
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
  }
}


