import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_filter_payload.dart';
import 'package:music_player/utils/api_request.dart';
import 'package:music_player/utils/url.dart';

import '../../../redux/models/music_item.dart';

class LoadHomePageMusicAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final tempRes = await ApiRequest.get(AppUrl.loadPayloadForFilterUrl);
      final musicFilterPayload =
          MusicFilterPayloadModel.fromApiResponse(tempRes);
      final res = await ApiRequest.post(
          AppUrl.homepageMusicUrl(musicFilterPayload.apiKey),
          musicFilterPayload.toJson());
      final json = jsonDecode(res.data.toString());
      final items = json['onResponseReceivedActions'][0]
          ['reloadContinuationItemsCommand']['continuationItems'] as List;
      final List<MusicItem> homeScreenMusicItems = [];
      for (var item in items) {
        final musicItem = item['richItemRenderer'];
        if (musicItem != null && musicItem['content'] != null) {
          if (musicItem['content']['videoRenderer'] != null) {
            homeScreenMusicItems
                .add(MusicItem.fromJson(musicItem['content']['videoRenderer']));
          } else {
            log('message');
          }
        }
      }
      log(homeScreenMusicItems.first.toString());
    } catch (err) {
      log(err.toString());
    }
  }
}

class GetMusicFilterPayloadAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final res = await ApiRequest.get(AppUrl.loadPayloadForFilterUrl);
      final musicFilterPayload = MusicFilterPayloadModel.fromApiResponse(res);
      log(musicFilterPayload.toString());
    } catch (err) {
      log(err.toString());
    }
  }
}
