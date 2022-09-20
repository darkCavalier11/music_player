// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:math' hide log;

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';

import '../redux/models/music_item.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return StreamBuilder<ProcessingState>(
            stream: snapshot.processingStateStream,
            builder: (context, musicSnapshot) {
              if (!musicSnapshot.hasData || musicSnapshot.hasError) {
                return const SizedBox.shrink();
              }
              return Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: MediaQuery.of(context).size.width *
                        (musicSnapshot.data! == ProcessingState.idle
                            ? 0.6
                            : 0.7),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).disabledColor,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              snapshot.onChange(0);
                            },
                            child: _BottomNavigationButton(
                              enabledText: 'Home',
                              icon: CupertinoIcons.home,
                              enabled: snapshot.currentBottomNavIndex == 0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              snapshot.onChange(1);
                            },
                            child: _BottomNavigationButton(
                              enabledText: 'Playlist',
                              icon: Iconsax.music_playlist,
                              enabled: snapshot.currentBottomNavIndex == 1,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              snapshot.onChange(2);
                            },
                            child: _BottomNavigationButton(
                              enabledText: 'Account',
                              icon: CupertinoIcons.person,
                              enabled: snapshot.currentBottomNavIndex == 2,
                            ),
                          ),
                          if (musicSnapshot.data! != ProcessingState.idle) ...[
                            Container(
                              height: 20,
                              width: 1,
                              color: Theme.of(context).hintColor,
                            ),
                            MusicPlayingSmallIndicator(
                              imageUrl: snapshot.musicItem!.imageUrl,
                              playingStream: snapshot.playingStream,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}

class MusicPlayingSmallIndicator extends StatefulWidget {
  final String imageUrl;
  final Stream<bool> playingStream;
  const MusicPlayingSmallIndicator({
    Key? key,
    required this.imageUrl,
    required this.playingStream,
  }) : super(key: key);

  @override
  State<MusicPlayingSmallIndicator> createState() =>
      _MusicPlayingSmallIndicatorState();
}

class _MusicPlayingSmallIndicatorState extends State<MusicPlayingSmallIndicator>
    with SingleTickerProviderStateMixin {
  @override
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _animationController.forward();
    _animationController.repeat(reverse: false);

    widget.playingStream.listen((event) {
      if (!event) {
        _animationController.stop();
      } else {
        _animationController.forward();
        _animationController.repeat(reverse: false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GestureDetector(
        onTap: () {
          // todo : expand to full playing screen
          // snapshot.onChange(2);
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                widget.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      builder: (context, child) {
        return Transform.rotate(
          angle: _animationController.value * 2 * pi,
          child: child,
        );
      },
    );
  }
}

class _BottomNavigationButton extends StatefulWidget {
  final IconData icon;
  final String enabledText;
  final bool enabled;
  const _BottomNavigationButton({
    Key? key,
    required this.icon,
    required this.enabledText,
    required this.enabled,
  }) : super(key: key);

  @override
  State<_BottomNavigationButton> createState() =>
      _BottomNavigationButtonState();
}

class _BottomNavigationButtonState extends State<_BottomNavigationButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: AnimatedSize(
        alignment: Alignment.topLeft,
        duration: const Duration(milliseconds: 400),
        child: Container(
          height: 45,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.enabled
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : null,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.enabled
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hintColor,
              ),
              const SizedBox(width: 4),
              if (widget.enabled)
                Text(
                  widget.enabledText,
                  style: Theme.of(context).textTheme.button?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends Vm {
  final int currentBottomNavIndex;
  final void Function(int) onChange;
  final Stream<ProcessingState> processingStateStream;
  final Stream<bool> playingStream;
  final MusicItem? musicItem;
  _ViewModel({
    required this.currentBottomNavIndex,
    required this.onChange,
    required this.processingStateStream,
    required this.playingStream,
    required this.musicItem,
  });
}

class _Factory extends VmFactory<AppState, BottomNavigationWidget> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      playingStream: state.audioPlayerState.audioPlayer.playingStream,
      musicItem: state.audioPlayerState.selectedMusic,
      currentBottomNavIndex: state.uiState.currentBottomNavIndex,
      onChange: (index) {
        dispatch(ChangeBottomNavIndex(index: index));
      },
      processingStateStream:
          state.audioPlayerState.audioPlayer.processingStateStream,
    );
  }
}
