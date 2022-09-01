// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:sembast/sembast.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_filter_payload.dart';
import 'package:music_player/utils/app_db.dart';

class SaveMusicFilterPayloadToDb extends ReduxAction<AppState> {
  final MusicFilterPayloadModel musicFilterPayload;
  SaveMusicFilterPayloadToDb({
    required this.musicFilterPayload,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final db = AppDatabse.mainDb;
      final store = StoreRef<String, String>.main();
      await store
          .record('music_filter_payload')
          .put(db, jsonEncode(musicFilterPayload.toJson()));
    } catch (err) {
      log(err.toString());
    }
  }
}
