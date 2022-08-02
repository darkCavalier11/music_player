import 'dart:math';

import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _AnimatedMusicWaveState();
}

class _AnimatedMusicWaveState extends State<LoadingIndicator>
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
              width: 9,
            ),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).primaryColor,
              ),
              height: 16 * cos(3 + _sizeAnimation.value + 10) + 30,
              width: 9,
            ),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).primaryColor,
              ),
              height: 3 + 4 * _sizeAnimation.value,
              width: 9,
            ),
          ],
        );
      },
    );
  }
}
