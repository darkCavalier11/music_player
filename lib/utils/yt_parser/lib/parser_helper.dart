import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../redux/models/music_filter_payload.dart';
import '../../../redux/models/music_item.dart';
import '../../api_request.dart';
import '../../app_db.dart';
import '../../url.dart';

class ParserHelper {
  static late MusicFilterPayloadModel musicFilterPayload;
  static Future<void> init() async {
    final dbRes = await AppDatabse.getQuery(DbKeys.context);
    if (dbRes != null) {
      musicFilterPayload = MusicFilterPayloadModel.fromJson(jsonDecode(dbRes));
    }
    final tempRes = await ApiRequest.get(AppUrl.loadPayloadForFilterUrl);
    musicFilterPayload = MusicFilterPayloadModel.fromApiResponse(tempRes);
    await AppDatabse.setQuery(
        DbKeys.context, jsonEncode(musicFilterPayload.toJson()));
  }

  static Future<List<MusicItem>> getHomeScreenMusic() async {
    try {
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
      return homeScreenMusicItems;
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current);
      throw Error.safeToString(err);
    }
  }

  static Future<List<MusicItem>> getNextSuggestionMusicList(String musicId) async {
    try {
      final res = await ApiRequest.post(
        AppUrl.nextMusicListUrl(musicFilterPayload.apiKey),
        {
          'context': musicFilterPayload.context.toJson(),
          'videoId': musicId,
        },
      );
      if (res.statusCode == 200) {
        final nextMusicList = <MusicItem>[];

        final nextMusicListResponse = jsonDecode(res.data!)['contents']
                ['twoColumnWatchNextResults']['secondaryResults']
            ['secondaryResults']['results'] as List;
        for (var item in nextMusicListResponse) {
          if (item['compactVideoRenderer'] != null) {
            if (item['compactVideoRenderer']['videoId'] != null) {
              nextMusicList.add(MusicItem.fromApiJson(
                  item['compactVideoRenderer'],
                  parsingForMusicList: true));
            } else {
              // todo : handle playlist
            }
          }
        }
        return nextMusicList;
      } else {
        return [];
      }
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current);
      throw ErrorDescription(err.toString());
    }
  }
}
