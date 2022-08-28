import 'package:fluro/fluro.dart';
import 'package:music_player/screens/music_search_result_screen/music_search_result_screen.dart';

import '../screens/music_search_screen/music_search_screen.dart';

class AppRouter {
  static FluroRouter router = FluroRouter();

  static final Handler _musicSearchPageHandler =
      Handler(handlerFunc: (context, params) {
    return const MusicSearchScreen();
  });

  static final Handler _musicSearchResultPageHandler =
      Handler(handlerFunc: (context, params) {
    return const MusicSearchResultScreen();
  });

  static void setupRoutes() {
    router.define(
      MusicSearchScreen.routeScreen,
      handler: _musicSearchPageHandler,
      transitionType: TransitionType.cupertinoFullScreenDialog,
    );

    router.define(
      MusicSearchResultScreen.routeName,
      handler: _musicSearchResultPageHandler,
      transitionType: TransitionType.cupertinoFullScreenDialog,
    );
  }
}
