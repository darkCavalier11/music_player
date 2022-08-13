import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/utils/constants.dart';

class BottomNavigationCluster extends StatefulWidget {
  const BottomNavigationCluster({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavigationCluster> createState() =>
      _BottomNavigationClusterState();
}

class _BottomNavigationClusterState extends State<BottomNavigationCluster> {
  Widget _homeIcon = const Icon(Iconsax.home1);
  Widget _favIcon = const Icon(CupertinoIcons.heart);
  Widget _playlistIcon = const Icon(Iconsax.music_playlist);
  Widget _accountIcon = const Icon(CupertinoIcons.person);

  void _selectNavByIndex(int index) {
    _navBarIndex = index;
    _homeIcon = const Icon(
      Iconsax.home_1,
      key: ValueKey<int>(0),
    );
    _favIcon = const Icon(
      CupertinoIcons.heart,
      key: ValueKey<int>(1),
    );
    _playlistIcon = const Icon(
      Iconsax.music_playlist,
      key: ValueKey<int>(2),
    );
    _accountIcon = const Icon(
      CupertinoIcons.person,
      key: ValueKey<int>(3),
    );
    switch (index) {
      case 0:
        _homeIcon = const Icon(
          Iconsax.home1,
          color: Colors.white,
          key: ValueKey<int>(10),
        );
        break;
      case 1:
        _favIcon = const Icon(
          CupertinoIcons.heart_fill,
          color: Colors.white,
          key: ValueKey<int>(11),
        );
        break;
      case 2:
        _playlistIcon = const Icon(
          Iconsax.music_playlist5,
          color: Colors.white,
          key: ValueKey<int>(12),
        );
        break;
      case 3:
        _accountIcon = const Icon(
          CupertinoIcons.person_fill,
          color: Colors.white,
          key: ValueKey<int>(14),
        );
        break;
    }
    setState(() {});
  }

  int _navBarIndex = 0;
  static double getIconPosition(double navBarWidth, int index) {
    switch (index) {
      case 0:
        return 9;
      case 1:
        return navBarWidth / 3 - 42;
      case 2:
        return 2 * navBarWidth / 3 - 94;
      default:
        return navBarWidth - 145;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectNavByIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            child: SizedBox(
              height: 240,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CircleAvatar(
                            maxRadius: 30,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sample Music',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                              ),
                              Text(
                                'Unknown',
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    ?.copyWith(
                                      color: Theme.of(context).backgroundColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        _PlayPauseButtonSet(),
                        _MarkFavWidget(
                          isFav: true,
                        )
                      ],
                    ),
                    _PlayTimerWidget(),
                  ],
                ),
              ),
            ),
          ),
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
                          MediaQuery.of(context).size.width, _navBarIndex),
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
                          _BottomNavigationBottom(
                            homeIcon: _homeIcon,
                            onTap: () {
                              _selectNavByIndex(0);
                            },
                          ),
                          _BottomNavigationBottom(
                            homeIcon: _favIcon,
                            onTap: () {
                              _selectNavByIndex(1);
                            },
                          ),
                          _BottomNavigationBottom(
                            homeIcon: _playlistIcon,
                            onTap: () {
                              _selectNavByIndex(2);
                            },
                          ),
                          _BottomNavigationBottom(
                            homeIcon: _accountIcon,
                            onTap: () {
                              _selectNavByIndex(3);
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
      ),
    );
  }
}

class _PlayTimerWidget extends StatefulWidget {
  const _PlayTimerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_PlayTimerWidget> createState() => _PlayTimerWidgetState();
}

class _PlayTimerWidgetState extends State<_PlayTimerWidget> {
  double posX = 50;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(0, -0.6),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 25,
            right: 25,
            bottom: 10,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: constraints.maxWidth,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Container(
                        width: posX,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                      Positioned(
                        left: posX - 2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Row(
                children: [
                  Text(
                    '1:34',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    '3:37',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onPanUpdate: ((details) {
            // * width of player is screen_width - 50 (25 padding each).
            if (details.globalPosition.dx < 25) {
              setState(() {
                posX = 0;
              });
            } else if (details.globalPosition.dx >
                MediaQuery.of(context).size.width - 25) {
              setState(() {
                posX = MediaQuery.of(context).size.width - 50;
              });
            } else {
              setState(() {
                posX = details.globalPosition.dx - 25;
              });
            }
          }),
          onPanStart: (details) {
            if (details.globalPosition.dx < 25) {
              setState(() {
                posX = 0;
              });
            } else if (details.globalPosition.dx >
                MediaQuery.of(context).size.width - 25) {
              setState(() {
                posX = MediaQuery.of(context).size.width - 50;
              });
            } else {
              setState(() {
                posX = details.globalPosition.dx - 25;
              });
            }
          },
          onPanEnd: ((details) {
            final _playerWidth = MediaQuery.of(context).size.width - 50;
            log((posX / _playerWidth).toString());
          }),
          child: Container(
            color: Colors.transparent,
            height: 20,
          ),
        ),
      ],
    );
  }
}

class _MarkFavWidget extends StatefulWidget {
  final bool isFav;
  const _MarkFavWidget({
    Key? key,
    required this.isFav,
  }) : super(key: key);

  @override
  State<_MarkFavWidget> createState() => _MarkFavWidgetState();
}

class _MarkFavWidgetState extends State<_MarkFavWidget> {
  late bool _isFav;
  @override
  void initState() {
    super.initState();
    _isFav = widget.isFav;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          setState(() {
            _isFav = !_isFav;
          });
        },
        icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: ((child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            }),
            child: _isFav
                ? Icon(
                    CupertinoIcons.heart_fill,
                    key: ValueKey<int>(0),
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : Icon(
                    CupertinoIcons.heart,
                    key: ValueKey<int>(1),
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
      ),
    );
  }
}

class _PlayPauseButtonSet extends StatefulWidget {
  const _PlayPauseButtonSet({
    Key? key,
  }) : super(key: key);

  @override
  State<_PlayPauseButtonSet> createState() => _PlayPauseButtonSetState();
}

class _PlayPauseButtonSetState extends State<_PlayPauseButtonSet> {
  bool _isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          setState(() {
            _isPlaying = !_isPlaying;
          });
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Icon(
            _isPlaying ? CupertinoIcons.pause : CupertinoIcons.play,
            size: 30,
            color: Theme.of(context).scaffoldBackgroundColor,
            key: ValueKey<bool>(_isPlaying),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationBottom extends StatelessWidget {
  final void Function() onTap;
  const _BottomNavigationBottom({
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
