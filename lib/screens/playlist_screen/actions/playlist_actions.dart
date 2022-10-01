// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/utils/app_db.dart';
import 'package:uuid/uuid.dart';

class CreateNewPlaylistWithMusicItem extends ReduxAction<AppState> {
  final MusicItem musicItem;
  final String playlistName;
  CreateNewPlaylistWithMusicItem({
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
            UserPlaylistListItem(
              id: const Uuid().v4(),
              title: playlistName,
              musicItems: [
                musicItem,
              ],
            ).toJson(),
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
