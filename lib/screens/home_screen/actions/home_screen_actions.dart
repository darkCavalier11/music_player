// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';
import 'package:music_player/env.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/redux_exception.dart';
import 'package:music_player/utils/update_model.dart';
import 'package:music_player/utils/yt_parser/lib/parser_helper.dart';

import '../../../redux/models/music_item.dart';
import '../../../utils/app_db.dart';
import '../../../utils/constants.dart';

class LoadHomePageMusicAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      dispatch(_SetHomeScreenLoadingAction(loadingState: LoadingState.loading));
      final homeScreenMusicItems = await ParserHelper.getHomeScreenMusic();
      dispatch(_SetHomeScreenLoadingAction(loadingState: LoadingState.idle));
      return state.copyWith(
        homePageState: state.homePageState.copyWith(
          homePageMusicList: homeScreenMusicItems,
        ),
      );
    } catch (err) {
      dispatch(_SetHomeScreenLoadingAction(loadingState: LoadingState.failed));
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'LoadHomePageMusicAction',
        userErrorToastMessage: 'Error loading music',
      );
    }
  }
}

class LoadRecentlyTappedMusicItemFromAppDbAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final recentlyTappedString =
          await AppDatabase.getQuery(DbKeys.recentlyTappedMusicItem);
      final recentlyTappedMusicItems =
          (jsonDecode(recentlyTappedString ?? '[]') as List)
              .map((e) => MusicItem.fromJson(e))
              .toList();
      return state.copyWith(
        searchState: state.searchState.copyWith(
          recentlyTappedMusicItems: recentlyTappedMusicItems,
        ),
      );
    } catch (err) {
      log('$err');
    }
  }
}

class _SetHomeScreenLoadingAction extends ReduxAction<AppState> {
  final LoadingState loadingState;
  _SetHomeScreenLoadingAction({
    required this.loadingState,
  });
  @override
  AppState reduce() {
    return state.copyWith(
      homePageState: state.homePageState.copyWith(
        homepageMusicListLoading: loadingState,
      ),
    );
  }
}

class _SetHomeScreenNextListLoadingAction extends ReduxAction<AppState> {
  final LoadingState loadingState;
  _SetHomeScreenNextListLoadingAction({
    required this.loadingState,
  });
  @override
  AppState reduce() {
    return state.copyWith(
      homePageState: state.homePageState.copyWith(
        homepageNextMusicListLoading: loadingState,
      ),
    );
  }
}

class GetNextMusicListForHomeScreenAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final homeScreenNextMusicList =
          await ParserHelper.getNextMusicListForHomeScreen();
      dispatch(
          _SetHomeScreenNextListLoadingAction(loadingState: LoadingState.idle));
      return state.copyWith(
        homePageState: state.homePageState.copyWith(
          homePageMusicList: state.homePageState.homePageMusicList
            ..addAll(homeScreenNextMusicList),
        ),
      );
    } catch (err) {
      dispatch(_SetHomeScreenNextListLoadingAction(
          loadingState: LoadingState.failed));
      log('GetNextMusicListForHomeScreenAction -> $err');
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'GetNextMusicListForHomeScreenAction',
        userErrorToastMessage: 'Error getting next music items',
      );
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(_SetHomeScreenNextListLoadingAction(
        loadingState: LoadingState.loading));
    return super.before();
  }
}

class GetUpdateModelAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    dispatch(_SetHomeScreenLoadingAction(loadingState: LoadingState.loading));
    try {
      final dio = Dio(
        BaseOptions(
          headers: {
            'X-Master-Key': EnvConfig.jsonBinMasterKey,
          },
        ),
      );
      final res = await dio.get(
        'https://api.jsonbin.io/v3/b/63cd5d8eace6f33a22c57b72',
      );
      if (res.statusCode == 200) {
        final updateModel = UpdateModel.fromJson(res.data['record']);
        dispatch(_SetHomeScreenLoadingAction(loadingState: LoadingState.idle));
        return state.copyWith(
          homePageState: state.homePageState.copyWith(
            updateModel: updateModel,
          ),
        );
      } else {
        throw Exception("error getting update info ${res.statusCode}");
      }
    } catch (err) {
      dispatch(_SetHomeScreenLoadingAction(loadingState: LoadingState.failed));
      log('$err');
    }
  }
}
