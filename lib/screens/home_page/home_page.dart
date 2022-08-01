import 'dart:developer';
import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/screens/home_page/widgets/bottom_navigation_cluster.dart';
import 'package:music_player/utils/swatch_generator.dart';

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
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.07),
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
                  Loading(),
                ],
              ),
              BottomNavigationCluster()
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     log("message");
          //     await snapshot.audioPlayer.setAudioSource(
          //       AudioSource.uri(
          //         Uri.parse(
          //             "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
          //         tag: MediaItem(
          //           id: '7',
          //           title: 'Random Title',
          //         ),
          //       ),
          //     );
          //     log("Ready to play");
          //     snapshot.audioPlayer
          //         .play(); // log(snapshot.audioPlayer.processingState.toString());
          //     await Future.delayed(Duration(seconds: 15));
          //     await snapshot.audioPlayer.stop();
          //   },
          //   child: Icon(Icons.play_arrow_rounded),
          // ),
        );
      },
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  State<Loading> createState() => _AnimatedMusicWaveState();
}

class _AnimatedMusicWaveState extends State<Loading>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      reverseDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _sizeAnimation =
        Tween<double>(begin: 0, end: 10).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        return Row(
          children: [
            const SizedBox(width: 20),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).primaryColor,
              ),
              height: 16 * sin(3 + _sizeAnimation.value + 40) + 20,
              width: 16,
            ),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).primaryColor,
              ),
              height: 16 * cos(3 + _sizeAnimation.value + 10) + 30,
              width: 16,
            ),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).primaryColor,
              ),
              height: 3 + 4 * _sizeAnimation.value,
              width: 16,
            ),
          ],
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
      audioPlayer: state.uiState.audioPlayer,
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
