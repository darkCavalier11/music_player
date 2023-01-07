// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:music_player/env.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/screens/app_page_view.dart';

import '../redux/models/music_item.dart';
import '../screens/music_item_controller_screen/music_item_controller_screen.dart';

class MusicPlayingSmallIndicator extends StatefulWidget {
  const MusicPlayingSmallIndicator({
    Key? key,
  }) : super(key: key);

  @override
  State<MusicPlayingSmallIndicator> createState() =>
      _MusicPlayingSmallIndicatorState();
}

class _MusicPlayingSmallIndicatorState extends State<MusicPlayingSmallIndicator>
    with SingleTickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        store.state.audioPlayerState.audioPlayer.playingStream.listen((event) {
          if (!mounted) {
            return;
          }
          if (!event) {
            if (_animationController.isAnimating) {
              _animationController.stop();
            }
          } else {
            _animationController.forward();
            _animationController.repeat(reverse: false);
          }
        });
      },
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return AnimatedBuilder(
          animation: _animationController,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, _, __) =>
                      const MusicListItemControllerScreen(),
                  opaque: false,
                ),
              );
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    snapshot.musicItem!.imageUrl,
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
      },
    );
  }
}

class _ViewModel extends Vm {
  final Stream<bool> playingStream;
  final MusicItem? musicItem;
  _ViewModel({
    required this.playingStream,
    required this.musicItem,
  }) : super(equals: [playingStream, musicItem]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.playingStream == playingStream && other.musicItem == musicItem;
  }

  @override
  int get hashCode => playingStream.hashCode ^ musicItem.hashCode;
}

class _Factory extends VmFactory<AppState, _MusicPlayingSmallIndicatorState> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel? fromStore() {
    return _ViewModel(
      playingStream: state.audioPlayerState.audioPlayer.playingStream,
      musicItem: state.audioPlayerState.selectedMusic,
    );
  }
}
