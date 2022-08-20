import 'package:fluro/fluro.dart';
import 'package:music_player/screens/search_page/music_search_screen.dart';

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
