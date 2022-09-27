import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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

  // load the list of music for home screen at the beginning
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
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw Error.safeToString(err);
    }
  }

  // When the current music item is clicked, it fetches the next set of music items
  // depending upon the current music Id.
  static Future<List<MusicItem>> getNextSuggestionMusicList(
      String musicId) async {
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
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw ErrorDescription(err.toString());
    }
  }

  static Future<Uri> getMusicItemUrl(String musicId) async {
    try {
      ApiRequest.post(
        AppUrl.playMusicUrl(musicFilterPayload.apiKey),
        {
          'context': musicFilterPayload.context.toJson(),
          'videoId': musicId,
        },
      );
      final yt = YoutubeExplode().videos.streamsClient;
      final m = await yt.getManifest(musicId);
      final musicUrl = m.audioOnly
          .firstWhere((element) => element.tag == 140)
          .url
          .toString();
      return Uri.parse(musicUrl);
    } catch (err) {
      rethrow;
    }
  }
}
