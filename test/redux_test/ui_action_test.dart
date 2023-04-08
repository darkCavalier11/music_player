import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('UI redux actions test', () {
    var store = Store<AppState>(initialState: AppState.initial());
    var storeTester = StoreTester.from(store);

    test('Test bottom navgation change', () async {
      storeTester.dispatch(ChangeBottomNavIndex(index: 1));
      final info = await storeTester.wait(ChangeBottomNavIndex);
      expect(info.state.uiState.currentBottomNavIndex, 1);
    });

    test('Test theme change', () async {
      storeTester.dispatch(ChangeThemeAction(themeMode: ThemeMode.dark));
      final info = await storeTester.wait(ChangeThemeAction);
      expect(info.state.uiState.themeMode, ThemeMode.dark);
    });
  });
}
