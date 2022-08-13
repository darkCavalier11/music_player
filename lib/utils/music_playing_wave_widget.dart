import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayingWaveWidget extends StatefulWidget {
  final Stream<bool> playingStream;
  const MusicPlayingWaveWidget({
    Key? key,
    required this.playingStream,
  }) : super(key: key);

  @override
  State<MusicPlayingWaveWidget> createState() => _AnimatedMusicWaveState();
}

class _AnimatedMusicWaveState extends State<MusicPlayingWaveWidget>
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
    );

    _sizeAnimation =
        Tween<double>(begin: 0, end: 10).animate(_animationController);
    widget.playingStream.listen((event) {
      if (!mounted) {
        return;
      }
      if (!event) {
        _animationController.stop();
      } else {
        _animationController.repeat(reverse: true);
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
              height: 3 * sin(3 + _sizeAnimation.value + 40) + 10,
              width: 4,
            ),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).primaryColor,
              ),
              height: 3 * cos(3 + _sizeAnimation.value + 10) + 20,
              width: 4,
            ),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).primaryColor,
              ),
              height: 3 + 2 * _sizeAnimation.value,
              width: 4,
            ),
          ],
        );
      },
    );
  }
}
