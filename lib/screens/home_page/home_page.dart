import 'dart:developer';
import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/screens/home_page/widgets/bottom_navigation_cluster.dart';
import 'package:music_player/screens/home_page/widgets/music_list_tile.dart';
import 'package:music_player/utils/constants.dart';

import '../../redux/action/ui_action.dart';
import '../../redux/models/app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: snapshot.uiState.themeMode == ThemeMode.light
              ? Colors.white
              : Colors.black,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, top: 64),
                    child: TextField(
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.music,
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
                  MusicListTile(
                    selectedMusic: MediaItem(
                      id: 'MUSIC_ID',
                      title: 'Ek Ladki Ko Dekha Toh Aisa Laga [Slowed+Reverb]',
                      artist: 'Darshan Raval',
                      artUri: Uri.parse(
                        'https://res.cloudinary.com/dftm6eyhx/video/upload/v1660413153/Ek_Ladki_Ko_Dekha_Toh_Aisa_Laga_Slowed_Reverb_-_Darshan_Raval___MUSIC_MANIA_LO-FI_q_MahaxjIEo_uxm3en.mp3',
                      ),
                    ),
                  ),
                  Divider(
                    endIndent: 20,
                    indent: 20,
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                  ),
                  MusicListTile(
                    selectedMusic: MediaItem(
                      id: 'MUSIC_ID_1',
                      title: 'Sample Music',
                      artist: 'Unknown',
                      artUri: Uri.parse(
                          'https://codeskulptor-demos.commondatastorage.googleapis.com/pang/paza-moduless.mp3'),
                    ),
                  ),
                ],
              ),
              BottomNavigationCluster(),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final UiState uiState;
  final AudioPlayer audioPlayer;
  final Function() toggleTheme;
  _ViewModel({
    required this.audioPlayer,
    required this.uiState,
    required this.toggleTheme,
  }) : super(equals: [uiState, audioPlayer]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ViewModel &&
        other.uiState == uiState &&
        other.audioPlayer == audioPlayer &&
        other.toggleTheme == toggleTheme;
  }

  @override
  int get hashCode =>
      uiState.hashCode ^ audioPlayer.hashCode ^ toggleTheme.hashCode;
}

class _Factory extends VmFactory<AppState, HomePage> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      audioPlayer: state.audioPlayerState.audioPlayer,
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
