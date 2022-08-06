import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/screens/home_page/actions/music_actions.dart';
import 'package:music_player/utils/loading_indicator.dart';
import 'package:music_player/utils/music_playing_wave_widget.dart';

class MusicListTile extends StatefulWidget {
  final MediaItem selectedMusic;
  const MusicListTile({
    Key? key,
    required this.selectedMusic,
  }) : super(key: key);

  @override
  State<MusicListTile> createState() => _MusicListTileState();
}

class _MusicListTileState extends State<MusicListTile> {
  Widget trailingWidget = PlayButtonWidget();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () async {
            if (snapshot.currentMusic?.id == widget.selectedMusic.id) {
              return;
            }
            final audioUri = AudioSource.uri(
              widget.selectedMusic.artUri ?? Uri(),
              tag: widget.selectedMusic,
            );
            await snapshot.audioPlayer.dispose();
            await snapshot.audioPlayer.setAudioSource(audioUri);
            await snapshot.setMediaItemState(widget.selectedMusic);
            await snapshot.audioPlayer.play();
            // await Future.delayed(const Duration(seconds: 5));
            await snapshot.audioPlayer.stop();
          },
          child: Container(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    CupertinoIcons.music_mic,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedMusic.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        widget.selectedMusic.artist ?? 'Unknown',
                        style: Theme.of(context).textTheme.overline?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: StreamBuilder<PlaybackEvent>(
                      stream: snapshot.audioPlayer.playbackEventStream,
                      builder: (context, playSnapshot) {
                        if (playSnapshot.hasError || !playSnapshot.hasData) {
                          // todo : add error handle, internet connection etc
                          trailingWidget = PlayButtonWidget();
                        } else if (playSnapshot.data!.processingState ==
                                ProcessingState.buffering &&
                            snapshot.currentMusic?.id ==
                                widget.selectedMusic.id) {
                          trailingWidget = LoadingIndicator.small(context);
                        } else if (playSnapshot.data!.processingState ==
                                ProcessingState.ready &&
                            snapshot.currentMusic?.id ==
                                widget.selectedMusic.id) {
                          trailingWidget = const MusicPlayingWaveWidget();
                        } else {
                          trailingWidget = PlayButtonWidget();
                        }
                        return Center(
                          child: trailingWidget,
                        );
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final AudioPlayer audioPlayer;
  final MediaItem? currentMusic;
  final Future<void> Function(MediaItem) setMediaItemState;
  _ViewModel({
    required this.audioPlayer,
    this.currentMusic,
    required this.setMediaItemState,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ViewModel &&
        other.audioPlayer == audioPlayer &&
        other.currentMusic == currentMusic &&
        other.setMediaItemState == setMediaItemState;
  }

  @override
  int get hashCode =>
      audioPlayer.hashCode ^ currentMusic.hashCode ^ setMediaItemState.hashCode;
}

class _Factory extends VmFactory<AppState, _MusicListTileState> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      setMediaItemState: (mediaItem) async {
        dispatch(
          SetMediaItemStateAction(selectedMusic: mediaItem),
        );
      },
      audioPlayer: state.audioPlayerState.audioPlayer,
      currentMusic: state.audioPlayerState.selectedMusic,
    );
  }
}

class PlayButtonWidget extends StatelessWidget {
  const PlayButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.play_arrow,
            size: 18,
          ),
          Text(
            '3:37',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
