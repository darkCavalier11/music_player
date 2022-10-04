// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/redux/models/app_state.dart';

class PlayPauseButtonSet extends StatelessWidget {
  const PlayPauseButtonSet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: StreamBuilder<bool>(
            stream: snapshot.audioPlayer.playingStream,
            builder: (context, stateSnapshot) {
              if (!stateSnapshot.hasData || stateSnapshot.hasError) {
                return const SizedBox.shrink();
              }
              return StreamBuilder<ProcessingState>(
                  stream: snapshot.audioPlayer.processingStateStream,
                  builder: (context, processingSnapshot) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Material(
                        color: Theme.of(context).primaryColor.withAlpha(0),
                        child: IconButton(
                          onPressed: () {
                            if (processingSnapshot.data ==
                                ProcessingState.completed) {
                              snapshot.audioPlayer
                                  .seek(const Duration(seconds: 0));
                              snapshot.audioPlayer.play();
                            } else if (stateSnapshot.data == true) {
                              snapshot.audioPlayer.pause();
                            } else {
                              snapshot.audioPlayer.play();
                            }
                          },
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: stateSnapshot.data == true
                                ? processingSnapshot.data ==
                                        ProcessingState.completed
                                    ? Icon(
                                        Iconsax.repeat,
                                        size: 25,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      )
                                    : Icon(
                                        CupertinoIcons.pause,
                                        size: 25,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      )
                                : Icon(
                                    CupertinoIcons.play_circle,
                                    size: 25,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
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

class _Factory extends VmFactory<AppState, PlayPauseButtonSet> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      audioPlayer: state.audioPlayerState.audioPlayer,
    );
  }
}
