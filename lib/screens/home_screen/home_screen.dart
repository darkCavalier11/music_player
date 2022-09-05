// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/redux/action/app_db_actions.dart';

import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/screens/home_screen/actions/home_screen_actions.dart';
import 'package:music_player/utils/constants.dart';

import '../../redux/action/ui_action.dart';
import '../../redux/models/app_state.dart';
import '../home_screen/widgets/music_list_tile.dart';
import '../music_search_screen/music_search_screen.dart';
import 'actions/music_actions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      onInit: (store) {
        store.dispatch(GetRecentlyPlayedMusicList());
        store.dispatch(LoadHomePageMusicAction());
      },
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: snapshot.uiState.themeMode == ThemeMode.light
              ? Colors.white
              : Colors.black,
          body: RefreshIndicator(
            onRefresh: () async {
              log('message');
            },
            color: Theme.of(context).primaryColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 64),
                    child: DummySearchTextField(
                      tag: 'search',
                      navigatingRouteName: MusicSearchScreen.routeScreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.stopwatch,
                          size: 35,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Recently played',
                          style: Theme.of(context).textTheme.button?.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ...snapshot.recentlyPlayedList
                      .take(5)
                      .map(
                        (e) => MusicListTile(
                          selectedMusic: e,
                          onTap: snapshot.playMusic,
                        ),
                      )
                      .toList(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 80),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColorLight,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'See More',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.mini_music_sqaure,
                          size: 35,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'For you',
                          style: Theme.of(context).textTheme.button?.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  ...snapshot.homeScreenMusicList
                      .map(
                        (e) => Column(
                          children: [
                            MusicListTile(
                              selectedMusic: e,
                              onTap: snapshot.playMusic,
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
  const DummySearchTextField({
    required this.navigatingRouteName,
    required this.tag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(navigatingRouteName);
        },
        child: Material(
          color: Colors.transparent,
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: const Icon(CupertinoIcons.search),
              fillColor: AppConstants.primaryColorLight,
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
  _ViewModel({
    required this.audioPlayer,
    required this.uiState,
    required this.toggleTheme,
    required this.homeScreenMusicList,
    required this.playMusic,
    required this.recentlyPlayedList,
  }) : super(equals: [
          uiState,
          audioPlayer,
          recentlyPlayedList,
          homeScreenMusicList,
        ]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.uiState == uiState &&
        other.audioPlayer == audioPlayer &&
        other.toggleTheme == toggleTheme &&
        listEquals(other.homeScreenMusicList, homeScreenMusicList);
  }

  @override
  int get hashCode {
    return uiState.hashCode ^
        audioPlayer.hashCode ^
        toggleTheme.hashCode ^
        homeScreenMusicList.hashCode;
  }
}

class _Factory extends VmFactory<AppState, HomeScreen> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      recentlyPlayedList: state.homePageState.recentlyPlayedMusicList,
      audioPlayer: state.audioPlayerState.audioPlayer,
      uiState: state.uiState,
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
          PlayAudioAction(mediaItem: mediaItem),
        );
      },
    );
  }
}
