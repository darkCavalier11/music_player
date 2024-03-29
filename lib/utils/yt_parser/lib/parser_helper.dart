import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../redux/models/music_filter_payload.dart';
import '../../../redux/models/music_item.dart';
import '../../api_request.dart';
import '../../app_db.dart';
import '../../url.dart';

class ParserHelper {
  /// when getting home screen music items , it will send the continuations
  /// string key for sending as a payload to get next set of music items
  static String? homeScreenNextContinuationKey;
  static Future<void> init() async {}

  static Future<List<MusicItem>> getHomeScreenMusic() async {
    try {
      return _getHomeScreenMusicHelper();
    } catch (err) {
      throw Error.safeToString(err);
    }
  }

  static Future<List<MusicItem>> getNextMusicListForHomeScreen() async {
    try {
      if (homeScreenNextContinuationKey == null) {
        return [];
      }
      return _getHomeScreenMusicHelper(fetchingNextList: true);
    } catch (err) {
      throw Error.safeToString(err);
    }
  }

  // load the list of music for home screen at the beginning
  static Future<List<MusicItem>> _getHomeScreenMusicHelper(
      {bool fetchingNextList = false}) async {
    try {
      final res = await ApiRequest.get(AppUrl.browseUrl());
      final doc = parse(res.data);
      final mainElement = doc
          .getElementsByTagName('script')
          .firstWhere((element) =>
              element.innerHtml.startsWith('var ytInitialData = {'))
          .innerHtml;
      final mainHtmlString = mainElement
          .replaceAll('var ytInitialData = ', '')
          .replaceFirst(';', '', mainElement.length - 40);
      if (res.statusCode == 200) {
        final json = jsonDecode(mainHtmlString);
        final items = (json['contents']['twoColumnBrowseResultsRenderer']
                ['tabs'] as List)[0]['tabRenderer']['content']
            ['richGridRenderer']['contents'];
        final List<MusicItem> homeScreenMusicItems = [];
        homeScreenNextContinuationKey = items.last?["continuationItemRenderer"]
            ?["continuationEndpoint"]?["continuationCommand"]?["token"];
        for (var item in items) {
          final musicItem = item['richItemRenderer'];
          if (musicItem != null && musicItem['content'] != null) {
            if (musicItem['content']['videoRenderer'] != null) {
              homeScreenMusicItems.add(
                  MusicItem.fromApiJson(musicItem['content']['videoRenderer']));
            } else {
              // todo : add playlist rendering
            }
          }
        }
        return homeScreenMusicItems;
      } else {
        throw Exception(
            "Error during getting music list, status code ${res.statusCode}, ${res.data}");
      }
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
        AppUrl.nextMusicListUrl(),
        ApiRequest.getNextListOfMusicPayload(musicId),
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
        throw Exception(
            "Error getting getNextSuggestionMusicList(), status code: ");
      }
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw ErrorDescription(err.toString());
    }
  }

  static Future<Uri> getMusicItemUrl(String musicId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final yt = YoutubeExplode().videos.streamsClient;
      final m = await yt.getManifest(musicId);
      final musicUrl = m.audioOnly
          .firstWhere((element) => element.tag == 140)
          .url
          .toString();
      await prefs.setString(musicId, musicUrl);
      return Uri.parse(musicUrl);
    } catch (err) {
      rethrow;
    }
  }
}
