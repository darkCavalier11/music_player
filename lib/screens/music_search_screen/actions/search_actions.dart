// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:html';

import 'package:async_redux/async_redux.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/utils/api_request.dart';
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
  Future<AppState> reduce() async {
    final res = await ApiRequest.get(AppUrl.suggestionUrl(query));
    print(res);
    return state;
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
