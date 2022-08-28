import 'dart:developer';
import 'dart:math' hide log;

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/screens/home_screen/widgets/bottom_navigation_cluster.dart';

import 'package:music_player/utils/constants.dart';

import '../../redux/action/ui_action.dart';
import '../../redux/models/app_state.dart';
import '../home_screen/widgets/music_list_tile.dart';
import '../music_search_screen/music_search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: snapshot.uiState.themeMode == ThemeMode.light
              ? Colors.white
              : Colors.black,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  artHeaders: {
                    'image_url':
                        'https://images.unsplash.com/photo-1661524852318-2b5d38aadfb8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                  },
                  artUri: Uri.parse(
                    'https://res.cloudinary.com/dftm6eyhx/video/upload/v1660413153/Ek_Ladki_Ko_Dekha_Toh_Aisa_Laga_Slowed_Reverb_-_Darshan_Raval___MUSIC_MANIA_LO-FI_q_MahaxjIEo_uxm3en.mp3',
                  ),
                ),
              ),
              MusicListTile(
                selectedMusic: MediaItem(
                  id: 'MUSIC_ID_1',
                  title: 'E Samaya',
                  artist: 'Kuldeep Pattanik',
                  artUri: Uri.parse(
                      'https://rr1---sn-cvh7kn6z.googlevideo.com/videoplayback?expire=1661014933&ei=Nb8AY6XhE5mJs8IP4_6F0AM&ip=202.137.213.111&id=o-ANtRJfG119ViZS5VeFC6JLFpvrALU46DQaGiKKJAhNPl&itag=251&source=youtube&requiressl=yes&mh=I7&mm=31%2C29&mn=sn-cvh7kn6z%2Csn-cvh76nlz&ms=au%2Crdu&mv=m&mvi=1&pl=24&pcm2=no&initcwndbps=1035000&vprv=1&mime=audio%2Fwebm&ns=fY3I57Cke81JP8LIf-1RAUMH&gir=yes&clen=5046302&dur=307.581&lmt=1610830804512911&mt=1660993031&fvip=2&keepalive=yes&fexp=24001373%2C24007246&c=WEB&rbqsm=fr&txp=5532434&n=hP-P__8ORRiwCdX8iH&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cpcm2%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRAIgME6lADatidKINvoj3c85rgwVuXYfqtooxfYA65gUyC4CIAxmUdvG0vZqAR3clpl7-x2hH0TFdrpwfwhL0x3BXbJO&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRAIgf6Afsh_gZ-ncd3GLfVUHASNcDJs-fyran_0WOyPc6e0CIC0soivQl9lSjdbndkXjWI0CB4TIf4ChrZVhVrv8o4Hb'),
                ),
                isPlaylist: true,
              ),
            ],
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

class _Factory extends VmFactory<AppState, HomeScreen> {
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
