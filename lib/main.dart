import 'package:async_redux/async_redux.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/screens/page_view_navigation.dart';
import 'package:music_player/utils/api_request.dart';
import 'package:music_player/utils/router.dart';
import 'package:music_player/utils/theme.dart';

late Store<AppState> store;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiRequest.init();
  AppRouter.setupRoutes();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  store = Store<AppState>(
    initialState: AppState.initial(),
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  runApp(StoreProvider<AppState>(store: store, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return MaterialApp(
          // todo : light theme
          themeMode: ThemeMode.light,
          theme: AppTheme.getTheme,
          darkTheme: AppTheme.getDarkTheme,
          debugShowCheckedModeBanner: false,
          home: const PageViewNavigation(),
          onGenerateRoute: AppRouter.router.generator,
        );
      },
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
