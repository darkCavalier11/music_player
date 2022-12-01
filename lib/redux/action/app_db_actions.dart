// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:music_player/redux/redux_exception.dart';

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
        return MusicItem.fromJson(e as Map<String, dynamic>);
      }).toList();

      if (oldmusicList
              .indexWhere((item) => item.musicId == musicItem.musicId) !=
          -1) {
        oldmusicList.removeWhere((item) => item.musicId == musicItem.musicId);
      }
      oldmusicList.add(musicItem);
      await AppDatabse.setQuery(DbKeys.recentlyPlayedList,
          jsonEncode(oldmusicList.map((e) => e.toJson()).toList()));
      dispatch(GetRecentlyPlayedMusicList());
    } catch (err) {
      throw ReduxException(
        errorMessage: err.toString(),
        actionName: 'AddItemToRecentlyPlayedList',
        userErrorToastMessage: 'Error Adding item to playlist'
      );
    }
    return null;
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
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw ReduxException(
        errorMessage: err.toString(),
        actionName: 'GetRecentlyPlayedMusicList',
        userErrorToastMessage: 'Error getting recently played list'
      );
    }
  }
}

class AddItemToSearchedItemList extends ReduxAction<AppState> {
  final String searchQuery;
  AddItemToSearchedItemList({
    required this.searchQuery,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final serialisedList = await AppDatabse.getQuery(DbKeys.searchedItemList);
      if (serialisedList == null) {
        await AppDatabse.setQuery(
            DbKeys.searchedItemList, jsonEncode([searchQuery]));
        return null;
      }
      final previouslySearchedItems = jsonDecode(serialisedList) as List;
      if (serialisedList.length == 5) {
        previouslySearchedItems.removeLast();
      }
      previouslySearchedItems.remove(searchQuery);
      previouslySearchedItems.add(searchQuery);
      AppDatabse.setQuery(DbKeys.searchedItemList,
          jsonEncode(previouslySearchedItems.reversed.toList()));
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw ReduxException(
        errorMessage: err.toString(),
        actionName: 'AddItemToSearchedItemList',
      );
    }
    return null;
  }
}

class GetSearchedItemList extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final serialisedList = await AppDatabse.getQuery(DbKeys.searchedItemList);
      if (serialisedList == null) {
        return null;
      }
      final previouslySearchedItems = jsonDecode(serialisedList) as List;
      return state.copyWith(
        searchState: state.searchState.copyWith(
          previouslySearchedItems:
              previouslySearchedItems.map((e) => e.toString()).toList(),
        ),
      );
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw ReduxException(
        errorMessage: err.toString(),
        actionName: 'GetSearchedItemList',
      );
    }
  }
}
