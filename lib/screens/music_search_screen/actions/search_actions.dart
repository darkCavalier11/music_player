// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:html/parser.dart';
import 'package:music_player/main.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/music_model.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/utils/api_request.dart';
import 'package:music_player/utils/loading_indicator.dart';
import 'package:music_player/utils/url.dart';

class _ChangeSearchQuery extends ReduxAction<AppState> {
  final String query;
  _ChangeSearchQuery({
    required this.query,
  });
  @override
  AppState reduce() {
    return state.copyWith(
      searchState: state.searchState.copyWith(
        query: query,
      ),
    );
  }
}

class _FetchSearchQueryResults extends ReduxAction<AppState> {
  final String query;
  _FetchSearchQueryResults({
    required this.query,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      dispatch(
          _SetSearchCurrentStateAction(loadingState: LoadingState.loading));
      final res = await ApiRequest.get(AppUrl.suggestionUrl(query));
      if (res.statusCode == 200) {
        dispatch(_SetSearchCurrentStateAction(loadingState: LoadingState.idle));
        final resultString =
            res.data?.replaceAll('window.google.ac.h(', '').replaceAll(')', '');
        final searchResult = MusicSearchResults.fromCustomJson(
            jsonDecode(resultString!) as List);
        return state.copyWith(
          searchState: state.searchState.copyWith(
            musicSearchResults: searchResult,
          ),
        );
      }
      dispatch(_SetSearchCurrentStateAction(loadingState: LoadingState.failed));
    } catch (err) {
      log(err.toString());
      dispatch(_SetSearchCurrentStateAction(loadingState: LoadingState.failed));
    }
  }
}

class OnChangeSearchQueryAction extends ReduxAction<AppState> {
  final String query;
  OnChangeSearchQueryAction({
    required this.query,
  });
  @override
  Future<AppState?> reduce() async {
    dispatch(_ChangeSearchQuery(query: query));
    dispatch(_FetchSearchQueryResults(query: query));
  }
}

class _SetSearchCurrentStateAction extends ReduxAction<AppState> {
  final LoadingState loadingState;
  _SetSearchCurrentStateAction({
    required this.loadingState,
  });
  @override
  AppState reduce() {
    return state.copyWith(
      searchState: state.searchState.copyWith(
        currentSeacrhState: loadingState,
      ),
    );
  }
}

class GetMusicItemFromQueryAction extends ReduxAction<AppState> {
  final String searchQuery;
  GetMusicItemFromQueryAction({
    required this.searchQuery,
  });
  @override
  Future<AppState?> reduce() async {
    try {
      final res = await ApiRequest.get(AppUrl.searchResultUrl(searchQuery));
      if (res.statusCode == 200) {
        final json = decodeHtmlResponse(res.data!);
        final items = json['contents']['twoColumnSearchResultsRenderer']
                ['primaryContents']['sectionListRenderer']['contents'][0]
            ['itemSectionRenderer']['contents'];
        final List<MusicItem> searchScreenMusicItems = [];
        for (var item in items) {
          if (item['videoRenderer'] != null) {
            searchScreenMusicItems
                .add(MusicItem.fromJson(item['videoRenderer']));
          } else if (item['radioRenderer'] != null) {
            log(item.toString());
          }
        }
        return state.copyWith(
          searchScreenMusicItems: searchScreenMusicItems,
        );
      }
    } catch (err) {
      log(err.toString());
    }
  }
}

dynamic decodeHtmlResponse(String response) {
  final scriptElements = parse(response).getElementsByTagName('script');
  final contentElement = scriptElements.firstWhere((element) {
    return element.innerHtml.startsWith('var ytInitialData');
  });
  final formatedJson = contentElement.innerHtml
      .replaceAll('var ytInitialData =', '')
      .replaceFirst(';', '', contentElement.innerHtml.length - 20);
  return jsonDecode(formatedJson);
}
