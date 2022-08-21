// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:async_redux/async_redux.dart';

import 'package:music_player/redux/models/app_state.dart';

class ChangeSearchQuery extends ReduxAction<AppState> {
  final String query;
  ChangeSearchQuery({
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

class FetchSearchQueryResults extends ReduxAction<AppState> {
  final String query;
  FetchSearchQueryResults({
    required this.query,
  });
  @override
  Future<AppState?> reduce() {
    throw UnimplementedError();
  }
}
