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
import 'package:palette_generator/palette_generator.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/screens/home_screen/actions/home_screen_actions.dart';
import 'package:music_player/screens/home_screen/widgets/play_pause_button.dart';
import 'package:music_player/screens/home_screen/widgets/player_timer_widget.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/music_circular_avatar.dart';

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
                      if (!paletteSnapshot.hasData ||
                          paletteSnapshot.hasError) {
                        return const SizedBox.shrink();
                      }
                      return AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: MediaQuery.of(context).size.width,
                        height: 140,
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
                                        TranslatingText(
                                            text:
                                                snapshot.selectedMusic?.title ??
                                                    '-',
                                            color: paletteSnapshot
                                                .data
                                                ?.dominantColor
                                                ?.titleTextColor),
                                        Text(
                                          snapshot.selectedMusic?.author ??
                                              'Unknown',
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
              )),
            ],
          );
        },
      ),
    );
  }
}

class TranslatingText extends StatefulWidget {
  final String text;
  final Color? color;
  const TranslatingText({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  State<TranslatingText> createState() => _TranslatingTextState();
}

class _TranslatingTextState extends State<TranslatingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  double textWidth = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.text.length),
    );
    _animationController.forward();
    _animationController.repeat(reverse: false);
    textWidth = (TextPainter(
            text: TextSpan(
              text: widget.text,
              style: const TextStyle(fontSize: 16),
            ),
            maxLines: 1,
            textScaleFactor: 1,
            textDirection: TextDirection.ltr)
          ..layout())
        .size
        .width;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TranslatingText oldWidget) {
    if (oldWidget.text != widget.text) {
      textWidth = (TextPainter(
              text: TextSpan(
                text: widget.text,
                style: const TextStyle(fontSize: 16),
              ),
              maxLines: 1,
              textScaleFactor: 1,
              textDirection: TextDirection.ltr)
            ..layout())
          .size
          .width;
      _animationController..duration = Duration(seconds: widget.text.length);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: Row(
        children: [
          Flexible(
            child: Text(
              widget.text,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: widget.color ??
                        Theme.of(context).scaffoldBackgroundColor,
                  ),
            ),
          ),
        ],
      ),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraint) {
            if (constraint.maxWidth >= textWidth) return child!;
            return Container(
              width: constraint.maxWidth,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Transform.translate(
                // todo: need to change the hacky logic
                offset: Offset(
                    _animationController.value <= 0.72
                        ? -1 / 0.72 * textWidth * _animationController.value
                        : 2 *
                            (constraint.maxWidth) *
                            (1 - _animationController.value) *
                            1 /
                            (1 - 0.72),
                    0),
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final Stream<ProcessingState> processingStateStream;
  final MusicItem? selectedMusic;
  final int currentBottomNavIndex;
  final Function(int) changeBottomNavIndex;
  _ViewModel({
    required this.processingStateStream,
    required this.selectedMusic,
    required this.currentBottomNavIndex,
    required this.changeBottomNavIndex,
  });

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.processingStateStream == processingStateStream &&
      other.selectedMusic == selectedMusic &&
      other.currentBottomNavIndex == currentBottomNavIndex &&
      other.changeBottomNavIndex == changeBottomNavIndex;
  }

  @override
  int get hashCode {
    return processingStateStream.hashCode ^
      selectedMusic.hashCode ^
      currentBottomNavIndex.hashCode ^
      changeBottomNavIndex.hashCode;
  }
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
