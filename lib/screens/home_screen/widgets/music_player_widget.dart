// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:math' hide log;

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/screens/home_screen/widgets/play_pause_button.dart';
import 'package:music_player/screens/home_screen/widgets/player_timer_widget.dart';
import 'package:music_player/utils/music_circular_avatar.dart';

class MusicPlayerWidget extends StatelessWidget {
  const MusicPlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return SizedBox(
          height: snapshot.selectedMusic == null ? 0 : 210,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: FutureBuilder<PaletteGenerator>(
                    future: snapshot.selectedMusic?.imageUrl != null
                        ? PaletteGenerator.fromImageProvider(
                            NetworkImage(snapshot.selectedMusic!.imageUrl),
                          )
                        : Future.value(
                            PaletteGenerator.fromColors(
                              [
                                PaletteColor(Theme.of(context).primaryColor, 1),
                              ],
                            ),
                          ),
                    builder: (context, paletteSnapshot) {
                      if (!paletteSnapshot.hasData ||
                          paletteSnapshot.hasError) {
                        return const SizedBox.shrink();
                      }
                      return AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        decoration: BoxDecoration(
                          color: paletteSnapshot.data?.dominantColor?.color ??
                              Colors.red,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: MusicCircularAvatar(
                                    imageUrl: snapshot.selectedMusic?.imageUrl,
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
                                        // Text('Hello'),
                                        SizedBox(
                                          height: 25,
                                          child: Marquee(
                                            text:
                                                snapshot.selectedMusic?.title ??
                                                    '-',
                                            scrollAxis: Axis.horizontal,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    color: paletteSnapshot
                                                        .data
                                                        ?.dominantColor
                                                        ?.titleTextColor),
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            blankSpace: 60.0,
                                            velocity: 30,
                                          ),
                                        ),
                                        Text(
                                          snapshot.selectedMusic?.author ??
                                              'Unknown',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline
                                              ?.copyWith(
                                                  color: paletteSnapshot
                                                          .data
                                                          ?.dominantColor
                                                          ?.titleTextColor ??
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
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Material(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(0),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Iconsax.next,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            PlayTimerWidget(
                              progressBarColor:
                                  paletteSnapshot.data?.vibrantColor?.color,
                              textColor: paletteSnapshot
                                  .data?.dominantColor?.bodyTextColor,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              // Minimize the current music player
              FutureBuilder<PaletteGenerator>(
                future: snapshot.selectedMusic?.imageUrl != null
                    ? PaletteGenerator.fromImageProvider(
                        CachedNetworkImageProvider(
                            snapshot.selectedMusic?.imageUrl ?? ''))
                    : Future.value(
                        PaletteGenerator.fromColors([
                          PaletteColor(Theme.of(context).primaryColor, 1),
                        ]),
                      ),
                builder: (context, paletteSnapshot) {
                  return Positioned(
                    top: -25,
                    left: 5,
                    child: Icon(
                      CupertinoIcons.chevron_down_circle_fill,
                      color: paletteSnapshot.data?.dominantColor?.color,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final Stream<ProcessingState> processingStateStream;
  final MusicItem? selectedMusic;
  final int currentBottomNavIndex;
  _ViewModel({
    required this.processingStateStream,
    required this.selectedMusic,
    required this.currentBottomNavIndex,
  });

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.processingStateStream == processingStateStream &&
        other.selectedMusic == selectedMusic &&
        other.currentBottomNavIndex == currentBottomNavIndex;
  }

  @override
  int get hashCode {
    return processingStateStream.hashCode ^
        selectedMusic.hashCode ^
        currentBottomNavIndex.hashCode;
  }
}

class _Factory extends VmFactory<AppState, MusicPlayerWidget> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      selectedMusic: state.audioPlayerState.selectedMusic,
      processingStateStream:
          state.audioPlayerState.audioPlayer.processingStateStream,
      currentBottomNavIndex: state.uiState.currentBottomNavIndex,
    );
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
