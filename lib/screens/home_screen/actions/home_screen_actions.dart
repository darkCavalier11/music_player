// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_filter_payload.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/utils/api_request.dart';
import 'package:music_player/utils/app_db.dart';
import 'package:music_player/utils/url.dart';

import '../../../redux/models/music_item.dart';

class LoadHomePageMusicAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      _SetHomeScreenLoadingAction(loadingState: LoadingState.loading);
      final tempRes = await ApiRequest.get(AppUrl.loadPayloadForFilterUrl);
      final musicFilterPayload =
          MusicFilterPayloadModel.fromApiResponse(tempRes);
      await AppDatabse.setQuery(
          DbKeys.context, jsonEncode(musicFilterPayload.toJson()));
      final res =
          await ApiRequest.post(AppUrl.browseUrl(musicFilterPayload.apiKey), {
        'context': musicFilterPayload.context.toJson(),
        'continuation': musicFilterPayload.continuation
      });
      final json = jsonDecode(res.data.toString());
      final items = json['onResponseReceivedActions'][0]
          ['reloadContinuationItemsCommand']['continuationItems'] as List;
      final List<MusicItem> homeScreenMusicItems = [];
      for (var item in items) {
        final musicItem = item['richItemRenderer'];
        if (musicItem != null && musicItem['content'] != null) {
          if (musicItem['content']['videoRenderer'] != null) {
            homeScreenMusicItems.add(
                MusicItem.fromApiJson(musicItem['content']['videoRenderer']));
          } else {}
        }
      }
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