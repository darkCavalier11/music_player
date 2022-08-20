// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/app_state.dart';

class ChangeThemeAction extends ReduxAction<AppState> {
  final ThemeMode themeMode;
  ChangeThemeAction({
    required this.themeMode,
  });
  @override
  AppState reduce() {
    return state.copyWith(
      uiState: state.uiState.copyWith(
        themeMode: themeMode,
      ),
    );
  }
}

class ChangeBottomNavIndex extends ReduxAction<AppState> {
  final int index;
  ChangeBottomNavIndex({
    required this.index,
  });
  @override
  AppState reduce() {
    return state.copyWith(
      uiState: state.uiState.copyWith(
        currentBottomNavIndex: index,
      ),
    );
  }
}
