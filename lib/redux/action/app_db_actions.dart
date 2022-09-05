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
        AppDatabse.setQuery(
            DbKeys.recentlyPlayedList, jsonEncode([musicItem.toJson()]));
        return null;
      }
      final oldmusicList = (jsonDecode(serialisedList) as List).map((e) {
        return MusicItem.fromJson(e);
      }).toList();
      if (oldmusicList.contains(musicItem)) {
        oldmusicList.remove(musicItem);
      }
      oldmusicList.add(musicItem);
      await AppDatabse.setQuery(DbKeys.recentlyPlayedList,
          jsonEncode(oldmusicList.map((e) => e.toJson()).toList()));
      dispatch(GetRecentlyPlayedMusicList());
    } catch (err) {
      log(err.toString());
    }
  }
}

class GetRecentlyPlayedMusicList extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final serialisedList =
          await AppDatabse.getQuery(DbKeys.recentlyPlayedList);
      if (serialisedList == null) {
        return null;
      }
      final musicList = jsonDecode(serialisedList) as List;
      return state.copyWith(
        homePageState: state.homePageState.copyWith(
          recentlyPlayedMusicList: musicList
              .map((e) => MusicItem.fromJson(e))
              .toList()
              .reversed
              .toList(),
        ),
      );
    } catch (err) {
      log(err.toString());
    }
  }
}
