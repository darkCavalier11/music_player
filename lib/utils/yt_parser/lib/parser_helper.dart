import 'dart:convert';

import '../../../redux/models/music_filter_payload.dart';
import '../../../redux/models/music_item.dart';
import '../../api_request.dart';
import '../../app_db.dart';
import '../../url.dart';

class ParserHelper {
  static Future<List<MusicItem>> getHomeScreenMusic() async {
    final tempRes = await ApiRequest.get(AppUrl.loadPayloadForFilterUrl);
    final musicFilterPayload = MusicFilterPayloadModel.fromApiResponse(tempRes);
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
    return homeScreenMusicItems;
  }
}
