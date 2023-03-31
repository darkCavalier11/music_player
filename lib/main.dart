// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:async_redux/async_redux.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/screens/onboarding/onboarding.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/action/user_profile_actions.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/redux_exception_wrapper.dart';
import 'package:music_player/screens/app_page_view.dart';
import 'package:music_player/utils/api_request.dart';
import 'package:music_player/utils/app_db.dart';
import 'package:music_player/utils/router.dart';
import 'package:music_player/utils/theme.dart';
import 'package:music_player/utils/yt_parser/lib/parser_helper.dart';

late Store<AppState> store;

late String appVersion;
late String currentBuildNumber;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await AppDatabase.init();
  await ApiRequest.init();
  await ParserHelper.init();
  AppRouter.setupRoutes();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    preloadArtwork: true,
    androidShowNotificationBadge: true,
  );
  store = Store<AppState>(
    initialState: AppState.initial(),
    wrapError: ReduxExceptionWrapper(),
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;
  currentBuildNumber = packageInfo.buildNumber;
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
      onInit: (store) async {
        store.dispatch(LoadUserProfileFromSharedPref());
      },
      builder: (context, snapshot) {
        return MaterialApp(
          // todo : light theme
          theme: AppTheme.getTheme,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.router.generator,
          home: StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, connectivitySnapshot) {
              if (connectivitySnapshot.hasData &&
                  !connectivitySnapshot.hasError) {
                if (connectivitySnapshot.data! == ConnectivityResult.none) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(CupertinoIcons.wifi_slash),
                          Text('No Internet connection'),
                        ],
                      ),
                    ),
                  );
                }
              }
              return !snapshot.isOnboardingDone
                  ? const OnboardingScreen()
                  : const AppScreens();
            },
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final UiState uiState;
  final Function() toggleTheme;
  final bool isOnboardingDone;
  _ViewModel({
    required this.uiState,
    required this.toggleTheme,
    required this.isOnboardingDone,
  }) : super(equals: [uiState, isOnboardingDone]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.uiState == uiState &&
        other.toggleTheme == toggleTheme &&
        other.isOnboardingDone == isOnboardingDone;
  }

  @override
  int get hashCode =>
      uiState.hashCode ^ toggleTheme.hashCode ^ isOnboardingDone.hashCode;

  _ViewModel copyWith({
    UiState? uiState,
    Function()? toggleTheme,
    bool? isOnboardingDone,
  }) {
    return _ViewModel(
      uiState: uiState ?? this.uiState,
      toggleTheme: toggleTheme ?? this.toggleTheme,
      isOnboardingDone: isOnboardingDone ?? this.isOnboardingDone,
    );
  }

  @override
  String toString() =>
      '_ViewModel(uiState: $uiState, toggleTheme: $toggleTheme, isOnboardingDone: $isOnboardingDone)';
}

class _Factory extends VmFactory<AppState, MyApp> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      isOnboardingDone: store.state.userProfileState.isOnBoardingDone,
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
