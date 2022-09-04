// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/utils/app_db.dart';

class AddItemToRecentlyPlayedList extends ReduxAction<AppState> {
  final MusicItem musicItem;
  AddItemToRecentlyPlayedList({
    required this.musicItem,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final serialisedList =
          await AppDatabse.getQuery(DbKeys.recentlyPlayedList);
      if (serialisedList == null) {
        AppDatabse.setQuery(DbKeys.recentlyPlayedList, jsonEncode([musicItem]));
        return null;
      }
      final oldmusicList = (jsonDecode(serialisedList) as List)
          .map((e) => MusicItem.fromJson(e))
          .toList();
      oldmusicList.add(musicItem);
      AppDatabse.setQuery(DbKeys.recentlyPlayedList,
          jsonEncode(oldmusicList.map((e) => e.toJson()).toList()));
    } catch (err) {
      log(err.toString());
    }
  }
}
