// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/main.dart';

import 'package:music_player/redux/action/app_db_actions.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/screens/home_screen/actions/home_screen_actions.dart';
import 'package:music_player/screens/home_screen/widgets/music_grid_tile.dart';
import 'package:music_player/screens/recently_played_screen/recently_played_screen.dart';
import 'package:music_player/utils/update_model.dart';
import 'package:music_player/widgets/loading_indicator.dart';
import 'package:music_player/widgets/text_themes/app_header_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../redux/action/ui_action.dart';
import '../../redux/models/app_state.dart';
import '../../redux/models/search_state.dart';
import '../../utils/constants.dart';
import '../../widgets/app_primary_button.dart';
import '../home_screen/widgets/music_list_tile.dart';
import '../music_search_screen/music_search_screen.dart';
import 'actions/music_actions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      onInit: (store) {
        store.dispatch(GetRecentlyPlayedMusicList());
        store.dispatch(LoadHomePageMusicAction());
        store.dispatch(GetUpdateModelAction());
        store.dispatch(LoadRecentlyTappedMusicItemFromAppDbAction());
      },
      builder: (context, snapshot) {
        return Scaffold(
          body: snapshot.homeScreenLoadingState == LoadingState.loading
              ? const Center(
                  child: LoadingIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    snapshot.loadHomePageMusic();
                  },
                  color: Theme.of(context).primaryColor,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController
                      ..addListener(() {
                        if (_scrollController.position.atEdge &&
                            _scrollController.offset > 0) {
                          snapshot.getNextMusicListForHomeScreen();
                        }
                      }),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 24, right: 24, top: 64),
                          child: DummySearchTextField(
                            tag: 'search',
                            navigatingRouteName: MusicSearchScreen.routeScreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (snapshot.updateModel.latestBuildNumber >
                            int.parse(currentBuildNumber))
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunchUrlString(
                                  'https://iridescent-trifle-5d3757.netlify.app/#/')) {
                                launchUrlString(
                                  "https://iridescent-trifle-5d3757.netlify.app/#/",
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Hey, a new app update available, 🎉',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .disabledColor),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_circle_right_outlined),
                                ],
                              ),
                            ),
                          ),
                        if (snapshot.recentlyPlayedList.isNotEmpty) ...[
                          const Divider(),
                          const Padding(
                            padding: EdgeInsets.only(left: 24),
                            child: AppHeaderText(
                              icon: Iconsax.timer_1,
                              text: 'Recently played',
                            ),
                          ),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(left: 24),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, idx) {
                                return MusicGridTile(
                                  selectedMusic:
                                      snapshot.recentlyPlayedList[idx],
                                  isSecondary: false,
                                  clearEarlierPlaylist: true,
                                );
                              },
                              itemCount:
                                  snapshot.recentlyPlayedList.take(5).length,
                            ),
                          ),
                          AppPrimaryButton(
                            buttonText: 'See More',
                            trailingIcon: CupertinoIcons.arrow_right,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  RecentlyPlayedScreen.recentlyPlayedScreen);
                            },
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: AppHeaderText(
                            icon: Iconsax.music_dashboard,
                            text: 'For you',
                          ),
                        ),
                        ...snapshot.homeScreenMusicList
                            .map(
                              (e) => Column(
                                children: [
                                  MusicListTile(
                                    selectedMusic: e,
                                  ),
                                  const Divider(
                                    endIndent: 50,
                                    indent: 50,
                                    height: 5,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        if (snapshot.homepageNextMusicListLoading ==
                            LoadingState.loading)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CupertinoActivityIndicator(),
                          ),
                        const SizedBox(
                          height: 250,
                        )
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

// responsible for holding a dummy text field that will navigate on tap to a different route.
class DummySearchTextField extends StatelessWidget {
  final String tag;
  final String navigatingRouteName;
  final bool? shouldPopCurrentRoute;
  const DummySearchTextField({
    required this.navigatingRouteName,
    required this.tag,
    this.shouldPopCurrentRoute,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: GestureDetector(
        onTap: () async {
          if (shouldPopCurrentRoute == true) {
            Navigator.of(context).pop();
          }
          Navigator.of(context).pushNamed(navigatingRouteName);
        },
        child: Material(
          color: Colors.transparent,
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: Theme.of(context).primaryColor,
              ),
              filled: true,
              hintText: 'Search songs, artist & genres...',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends Vm {
  final UiState uiState;
  final AudioPlayer audioPlayer;
  final Function() toggleTheme;
  final List<MusicItem> homeScreenMusicList;
  final List<MusicItem> recentlyPlayedList;
  final void Function(MusicItem) playMusic;
  final void Function() getNextMusicListForHomeScreen;
  final LoadingState homepageNextMusicListLoading;
  final void Function() loadHomePageMusic;
  final UpdateModel updateModel;

  final LoadingState homeScreenLoadingState;
  _ViewModel({
    required this.loadHomePageMusic,
    required this.audioPlayer,
    required this.uiState,
    required this.toggleTheme,
    required this.homeScreenMusicList,
    required this.playMusic,
    required this.recentlyPlayedList,
    required this.getNextMusicListForHomeScreen,
    required this.homepageNextMusicListLoading,
    required this.homeScreenLoadingState,
    required this.updateModel,
  }) : super(equals: [
          uiState,
          audioPlayer,
          recentlyPlayedList,
          homeScreenMusicList,
          homepageNextMusicListLoading,
          homeScreenLoadingState,
          updateModel,
        ]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.uiState == uiState &&
        other.audioPlayer == audioPlayer &&
        other.toggleTheme == toggleTheme &&
        listEquals(other.homeScreenMusicList, homeScreenMusicList) &&
        listEquals(other.recentlyPlayedList, recentlyPlayedList) &&
        other.playMusic == playMusic &&
        other.getNextMusicListForHomeScreen == getNextMusicListForHomeScreen &&
        other.homepageNextMusicListLoading == homepageNextMusicListLoading &&
        other.loadHomePageMusic == loadHomePageMusic &&
        other.updateModel == updateModel &&
        other.homeScreenLoadingState == homeScreenLoadingState;
  }

  @override
  int get hashCode {
    return uiState.hashCode ^
        audioPlayer.hashCode ^
        toggleTheme.hashCode ^
        homeScreenMusicList.hashCode ^
        recentlyPlayedList.hashCode ^
        playMusic.hashCode ^
        getNextMusicListForHomeScreen.hashCode ^
        homepageNextMusicListLoading.hashCode ^
        loadHomePageMusic.hashCode ^
        updateModel.hashCode ^
        homeScreenLoadingState.hashCode;
  }

  _ViewModel copyWith({
    UiState? uiState,
    AudioPlayer? audioPlayer,
    Function()? toggleTheme,
    List<MusicItem>? homeScreenMusicList,
    List<MusicItem>? recentlyPlayedList,
    void Function(MusicItem)? playMusic,
    void Function()? getNextMusicListForHomeScreen,
    LoadingState? homepageNextMusicListLoading,
    void Function()? loadHomePageMusic,
    UpdateModel? updateModel,
    LoadingState? homeScreenLoadingState,
  }) {
    return _ViewModel(
      uiState: uiState ?? this.uiState,
      audioPlayer: audioPlayer ?? this.audioPlayer,
      toggleTheme: toggleTheme ?? this.toggleTheme,
      homeScreenMusicList: homeScreenMusicList ?? this.homeScreenMusicList,
      recentlyPlayedList: recentlyPlayedList ?? this.recentlyPlayedList,
      playMusic: playMusic ?? this.playMusic,
      getNextMusicListForHomeScreen:
          getNextMusicListForHomeScreen ?? this.getNextMusicListForHomeScreen,
      homepageNextMusicListLoading:
          homepageNextMusicListLoading ?? this.homepageNextMusicListLoading,
      loadHomePageMusic: loadHomePageMusic ?? this.loadHomePageMusic,
      updateModel: updateModel ?? this.updateModel,
      homeScreenLoadingState:
          homeScreenLoadingState ?? this.homeScreenLoadingState,
    );
  }

  @override
  String toString() {
    return '_ViewModel(uiState: $uiState, audioPlayer: $audioPlayer, toggleTheme: $toggleTheme, homeScreenMusicList: $homeScreenMusicList, recentlyPlayedList: $recentlyPlayedList, playMusic: $playMusic, getNextMusicListForHomeScreen: $getNextMusicListForHomeScreen, homepageNextMusicListLoading: $homepageNextMusicListLoading, loadHomePageMusic: $loadHomePageMusic, homeScreenLoadingState: $homeScreenLoadingState)';
  }
}

class _Factory extends VmFactory<AppState, _HomeScreenState> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      updateModel: state.homePageState.updateModel,
      loadHomePageMusic: () {
        dispatch(LoadHomePageMusicAction());
      },
      recentlyPlayedList: state.homePageState.recentlyPlayedMusicList,
      homeScreenLoadingState: state.homePageState.homepageMusicListLoading,
      audioPlayer: state.audioPlayerState.audioPlayer,
      uiState: state.uiState,
      homepageNextMusicListLoading:
          state.homePageState.homepageNextMusicListLoading,
      getNextMusicListForHomeScreen: () {
        dispatch(GetNextMusicListForHomeScreenAction());
      },
      toggleTheme: () {
        if (state.uiState.themeMode == ThemeMode.dark) {
          dispatch(ChangeThemeAction(themeMode: ThemeMode.light));
        } else {
          dispatch(ChangeThemeAction(themeMode: ThemeMode.dark));
        }
      },
      homeScreenMusicList: state.homePageState.homePageMusicList,
      playMusic: (mediaItem) async {
        await dispatch(
          PlayAudioAction(
            musicItem: mediaItem,
          ),
        );
      },
    );
  }
}
