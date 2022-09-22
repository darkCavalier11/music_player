// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/utils/yt_parser/lib/parser_helper.dart';


class LoadHomePageMusicAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      _SetHomeScreenLoadingAction(loadingState: LoadingState.loading);
      final homeScreenMusicItems = await ParserHelper.getHomeScreenMusic();
      _SetHomeScreenLoadingAction(loadingState: LoadingState.idle);
      return state.copyWith(
        homePageState: state.homePageState.copyWith(
          homePageMusicList: homeScreenMusicItems,
        ),
      );
    } catch (err) {
      _SetHomeScreenLoadingAction(loadingState: LoadingState.failed);
      log(err.toString(), stackTrace: StackTrace.current);
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
