import 'package:fluro/fluro.dart';

import '../screens/music_search_screen/music_search_screen.dart';

class AppRouter {
  static FluroRouter router = FluroRouter();

  static final Handler _musicSearchPageHandler =
      Handler(handlerFunc: (context, params) {
    return const MusicSearchScreen();
  });

  static void setupRoutes() {
    router.define(
      MusicSearchScreen.routeScreen,
      handler: _musicSearchPageHandler,
      transitionType: TransitionType.fadeIn,
    );
  }
}
