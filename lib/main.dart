import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/screens/home_page/home_page.dart';
import 'package:music_player/utils/swatch_generator.dart';
import 'package:music_player/utils/theme.dart';

late Store<AppState> store;
void main() {
  store = Store<AppState>(
    initialState: AppState.initial(),
  );
  runApp(StoreProvider<AppState>(store: store, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) => MaterialApp(
        // todo : light theme
        themeMode: ThemeMode.light,
        theme: AppTheme.getTheme,
        darkTheme: AppTheme.getDarkTheme,
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class _ViewModel extends Vm {
  final UiState uiState;
  final Function() toggleTheme;
  _ViewModel({
    required this.uiState,
    required this.toggleTheme,
  }) : super(equals: [uiState]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ViewModel &&
        other.uiState == uiState &&
        other.toggleTheme == toggleTheme;
  }

  @override
  int get hashCode => uiState.hashCode ^ toggleTheme.hashCode;
}

class _Factory extends VmFactory<AppState, MyApp> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      uiState: state.uiState,
      toggleTheme: () {
        if (state.uiState.themeMode == ThemeMode.dark) {
          dispatch(ChangeThemeAction(themeMode: ThemeMode.light));
        } else {
          dispatch(ChangeThemeAction(themeMode: ThemeMode.dark));
        }
      },
    );
  }
}
