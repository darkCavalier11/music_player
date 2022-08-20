import 'dart:async';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/audio_player_state.dart';
import 'package:music_player/utils/extensions.dart';

class PlayTimerWidget extends StatefulWidget {
  const PlayTimerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayTimerWidget> createState() => _PlayTimerWidgetState();
}

class _PlayTimerWidgetState extends State<PlayTimerWidget> {
  double posX = 0;
  bool _isPanning = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Stack(
          alignment: const Alignment(0, -0.6),
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return StreamBuilder<Duration?>(
                          stream: snapshot.audioPlayer.durationStream,
                          builder: (context, durationSnapshot) {
                            return StreamBuilder<Duration>(
                              stream: snapshot.audioPlayer.positionStream,
                              builder: (context, positionSnapshot) {
                                if (durationSnapshot.hasError ||
                                    !durationSnapshot.hasData) {
                                  return const SizedBox.shrink();
                                } else if (positionSnapshot.hasError ||
                                    !positionSnapshot.hasData) {
                                  return const SizedBox.shrink();
                                }
                                if (!_isPanning) {
                                  posX = positionSnapshot.data!.inMilliseconds /
                                      durationSnapshot.data!.inMilliseconds *
                                      constraints.maxWidth;
                                }
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
                                    StreamBuilder<Duration>(
                                        stream: snapshot
                                            .audioPlayer.bufferedPositionStream,
                                        builder: (context, bufferSnapshot) {
                                          if (!bufferSnapshot.hasData ||
                                              bufferSnapshot.hasError) {
                                            return const SizedBox.shrink();
                                          }
                                          final fractionCovered =
                                              ((bufferSnapshot.data
                                                          ?.inMicroseconds ??
                                                      0) /
                                                  (snapshot.audioPlayer.duration
                                                          ?.inMicroseconds ??
                                                      1));
                                          return Container(
                                            width: constraints.maxWidth *
                                                fractionCovered,
                                            height: 3,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          );
                                        }),
                                    Container(
                                      width: posX,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          topLeft: Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: posX - 4,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      StreamBuilder<Duration>(
                        stream: snapshot.audioPlayer.positionStream,
                        builder: (context, playerSnapshot) {
                          if (!playerSnapshot.hasData ||
                              playerSnapshot.hasError) {
                            return Text(
                              '-',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                            );
                          }
                          return Text(
                            playerSnapshot.data?.formatDurationString() ?? '-',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                          );
                        },
                      ),
                      const Spacer(),
                      StreamBuilder<Duration?>(
                        stream: snapshot.audioPlayer.durationStream,
                        builder: (context, playerSnapshot) {
                          if (!playerSnapshot.hasData ||
                              playerSnapshot.hasError) {
                            return Text(
                              '-',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                            );
                          }
                          return Text(
                            playerSnapshot.data?.formatDurationString() ?? '-',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onPanUpdate: ((details) {
                setState(() {
                  _isPanning = true;
                });
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
                setState(() {
                  _isPanning = true;
                });
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
              onPanEnd: ((details) async {
                setState(() {
                  _isPanning = false;
                });
                final _playerWidth = MediaQuery.of(context).size.width - 50;
                final _duration = await snapshot.audioPlayer.durationFuture;
                if (_duration != null) {
                  double _fractionCovered = posX / _playerWidth;
                  snapshot.audioPlayer.seek(Duration(
                      milliseconds:
                          (_duration.inMilliseconds * _fractionCovered)
                              .floor()));
                }
              }),
              child: Container(
                color: Colors.transparent,
                height: 20,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final AudioPlayer audioPlayer;
  _ViewModel({
    required this.audioPlayer,
  });
}

class _Factory extends VmFactory<AppState, _PlayTimerWidgetState> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      audioPlayer: state.audioPlayerState.audioPlayer,
    );
  }
}

class MarkFavWidget extends StatefulWidget {
  final bool isFav;
  const MarkFavWidget({
    Key? key,
    required this.isFav,
  }) : super(key: key);

  @override
  State<MarkFavWidget> createState() => _MarkFavWidgetState();
}

class _MarkFavWidgetState extends State<MarkFavWidget> {
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
                    size: 25,
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
