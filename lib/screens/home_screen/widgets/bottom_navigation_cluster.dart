// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:math' hide log;

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/screens/home_screen/widgets/play_pause_button.dart';
import 'package:music_player/screens/home_screen/widgets/player_timer_widget.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/music_circular_avatar.dart';
import 'package:palette_generator/palette_generator.dart';

class BottomNavigationCluster extends StatefulWidget {
  final Function(int) onPageChanged;
  const BottomNavigationCluster({
    Key? key,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  State<BottomNavigationCluster> createState() =>
      _BottomNavigationClusterState();
}

class _BottomNavigationClusterState extends State<BottomNavigationCluster> {
  static double getIconPosition(double navBarWidth, int index) {
    switch (index) {
      case 0:
        return 9;
      case 1:
        return navBarWidth / 3 - 14;
      case 2:
        return 2 * navBarWidth / 3 - 36;
      default:
        return navBarWidth - 59;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: StoreConnector<AppState, _ViewModel>(
        vm: () => _Factory(this),
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                  child: Visibility(
                visible: snapshot.selectedMusic != null,
                child: FutureBuilder<PaletteGenerator>(
                    future: snapshot.selectedMusic?.artHeaders?['image_url'] !=
                            null
                        ? PaletteGenerator.fromImageProvider(
                            CachedNetworkImageProvider(snapshot
                                    .selectedMusic?.artHeaders?['image_url'] ??
                                ''))
                        : Future.value(
                            PaletteGenerator.fromColors([
                              PaletteColor(Theme.of(context).primaryColor, 1),
                            ]),
                          ),
                    builder: (context, paletteSnapshot) {
                      if (!paletteSnapshot.hasData ||
                          paletteSnapshot.hasError) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        decoration: BoxDecoration(
                          color: paletteSnapshot.data?.dominantColor?.color,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: MusicCircularAvatar(
                                    imageUrl: snapshot.selectedMusic
                                        ?.artHeaders?['image_url'],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // todo : add trasition animation
                                        Text(
                                          snapshot.selectedMusic?.title ?? '-',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: paletteSnapshot
                                                        .data
                                                        ?.mutedColor
                                                        ?.bodyTextColor ??
                                                    Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                              ),
                                        ),
                                        Text(
                                          snapshot.selectedMusic?.artist ??
                                              'Unknown',
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline
                                              ?.copyWith(
                                                  color: paletteSnapshot
                                                          .data
                                                          ?.mutedColor
                                                          ?.bodyTextColor ??
                                                      Theme.of(context)
                                                          .scaffoldBackgroundColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const PlayPauseButtonSet(),
                                MarkFavWidget(
                                  isFav: true,
                                  color:
                                      paletteSnapshot.data?.vibrantColor?.color,
                                )
                              ],
                            ),
                            PlayTimerWidget(
                              progressBarColor: paletteSnapshot
                                  .data?.lightVibrantColor?.color,
                              textColor: paletteSnapshot
                                  .data?.mutedColor?.bodyTextColor,
                            ),
                          ],
                        ),
                      );
                    }),
              )),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColorLight,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          curve: Curves.fastOutSlowIn,
                          top: 10,
                          left: getIconPosition(
                              MediaQuery.of(context).size.width * 0.8,
                              snapshot.currentBottomNavIndex),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          duration: const Duration(milliseconds: 200),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BottomNavigationBottom(
                                homeIcon: snapshot.currentBottomNavIndex == 0
                                    ? const Icon(
                                        Iconsax.home1,
                                        color: Colors.white,
                                        key: ValueKey<int>(10),
                                      )
                                    : const Icon(
                                        Iconsax.home_1,
                                        key: ValueKey<int>(0),
                                      ),
                                onTap: () {
                                  widget.onPageChanged(0);
                                  snapshot.changeBottomNavIndex(0);
                                },
                              ),
                              BottomNavigationBottom(
                                homeIcon: snapshot.currentBottomNavIndex == 1
                                    ? const Icon(
                                        CupertinoIcons.heart_fill,
                                        color: Colors.white,
                                        key: ValueKey<int>(11),
                                      )
                                    : const Icon(
                                        CupertinoIcons.heart,
                                        key: ValueKey<int>(1),
                                      ),
                                onTap: () {
                                  widget.onPageChanged(1);
                                  snapshot.changeBottomNavIndex(1);
                                },
                              ),
                              BottomNavigationBottom(
                                homeIcon: snapshot.currentBottomNavIndex == 2
                                    ? const Icon(
                                        Iconsax.music_playlist5,
                                        color: Colors.white,
                                        key: ValueKey<int>(12),
                                      )
                                    : const Icon(
                                        Iconsax.music_playlist,
                                        key: ValueKey<int>(2),
                                      ),
                                onTap: () {
                                  widget.onPageChanged(2);
                                  snapshot.changeBottomNavIndex(2);
                                },
                              ),
                              BottomNavigationBottom(
                                homeIcon: snapshot.currentBottomNavIndex == 3
                                    ? const Icon(
                                        CupertinoIcons.person_fill,
                                        color: Colors.white,
                                        key: ValueKey<int>(10),
                                      )
                                    : const Icon(
                                        CupertinoIcons.person,
                                        key: ValueKey<int>(1),
                                      ),
                                onTap: () {
                                  widget.onPageChanged(3);
                                  snapshot.changeBottomNavIndex(3);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ViewModel extends Vm {
  final Stream<ProcessingState> processingStateStream;
  final MediaItem? selectedMusic;
  final int currentBottomNavIndex;
  final Function(int) changeBottomNavIndex;
  _ViewModel({
    required this.processingStateStream,
    required this.currentBottomNavIndex,
    required this.changeBottomNavIndex,
    required this.selectedMusic,
  });

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.processingStateStream == processingStateStream &&
        other.currentBottomNavIndex == currentBottomNavIndex &&
        other.changeBottomNavIndex == changeBottomNavIndex;
  }

  @override
  int get hashCode =>
      processingStateStream.hashCode ^
      currentBottomNavIndex.hashCode ^
      changeBottomNavIndex.hashCode;
}

class _Factory extends VmFactory<AppState, _BottomNavigationClusterState> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
        selectedMusic: state.audioPlayerState.selectedMusic,
        processingStateStream:
            state.audioPlayerState.audioPlayer.processingStateStream,
        currentBottomNavIndex: state.uiState.currentBottomNavIndex,
        changeBottomNavIndex: (index) {
          dispatch(ChangeBottomNavIndex(index: index));
        });
  }
}

class BottomNavigationBottom extends StatelessWidget {
  final void Function() onTap;
  const BottomNavigationBottom({
    required this.onTap,
    Key? key,
    required Widget homeIcon,
  })  : _homeIcon = homeIcon,
        super(key: key);

  final Widget _homeIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: AnimatedSwitcher(
          reverseDuration: const Duration(seconds: 0),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          duration: const Duration(milliseconds: 200),
          child: _homeIcon,
        ),
      ),
    );
  }
}
