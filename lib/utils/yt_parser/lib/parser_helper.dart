import 'dart:convert';
import 'dart:developer';

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
}
