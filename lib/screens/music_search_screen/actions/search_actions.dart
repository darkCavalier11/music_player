// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:html/parser.dart';

import 'package:music_player/redux/action/app_db_actions.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_filter_payload.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/music_model.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/redux/redux_exception.dart';
import 'package:music_player/screens/home_screen/actions/home_screen_actions.dart';
import 'package:music_player/utils/api_request.dart';
import 'package:music_player/utils/app_db.dart';
import 'package:music_player/utils/url.dart';

import '../../../utils/constants.dart';

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
        final searchResult = MusicSearchStringResults.fromCustomJson(
            jsonDecode(resultString!) as List);
        return state.copyWith(
          searchState: state.searchState.copyWith(
            musicSearchResults: searchResult,
          ),
        );
      }
      dispatch(_SetSearchCurrentStateAction(loadingState: LoadingState.failed));
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      dispatch(_SetSearchCurrentStateAction(loadingState: LoadingState.failed));
    }
    return null;
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
    return null;
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

class _SetSearchResultFetchingAction extends ReduxAction<AppState> {
  final LoadingState loadingState;
  _SetSearchResultFetchingAction({
    required this.loadingState,
  });
  @override
  AppState reduce() {
    return state.copyWith(
      searchState: state.searchState.copyWith(
        searchResultFetchingState: loadingState,
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
      dispatch(
          _SetSearchResultFetchingAction(loadingState: LoadingState.loading));
      dispatch(AddItemToSearchedItemList(searchQuery: searchQuery));
      String? payload = await AppDatabse.getQuery(DbKeys.context);
      if (payload == null) {
        await dispatch(LoadHomePageMusicAction());
      }
      payload = await AppDatabse.getQuery(DbKeys.context);
      if (payload == null) {
        return null;
      }
      final musicFilterPayload =
          MusicFilterPayloadModel.fromJson(jsonDecode(payload));
      final res = await ApiRequest.post(
        AppUrl.searchUrl(musicFilterPayload.apiKey),
        {
          'context': musicFilterPayload.context.toJson(),
          'query': searchQuery,
        },
      );
      if (res.statusCode == 200) {
        dispatch(
            _SetSearchResultFetchingAction(loadingState: LoadingState.idle));
        final musicResponseJson = jsonDecode(res.data!);
        final musicListItems = musicResponseJson['contents']
                    ['twoColumnSearchResultsRenderer']['primaryContents']
                ['sectionListRenderer']['contents'][0]['itemSectionRenderer']
            ['contents'] as List;
        final searchScreenMusicItems = <MusicItem>[];
        for (var item in musicListItems) {
          if (item['videoRenderer'] != null) {
            searchScreenMusicItems
                .add(MusicItem.fromApiJson(item['videoRenderer']));
          } else {}
        }

        return state.copyWith(
          searchState: state.searchState.copyWith(
            searchResultMusicItems: searchScreenMusicItems,
          ),
        );
      }
      dispatch(
          _SetSearchResultFetchingAction(loadingState: LoadingState.failed));
    } catch (err) {
      dispatch(
          _SetSearchResultFetchingAction(loadingState: LoadingState.failed));
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw ReduxException(
        errorMessage: '$err',
        actionName: 'GetMusicItemFromQueryAction',
        userErrorToastMessage: 'Unable to get search results!',
      );
    }
    return null;
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
