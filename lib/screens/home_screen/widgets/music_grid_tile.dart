import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/widgets/loading_indicator.dart';
import 'package:music_player/widgets/music_playing_wave_widget.dart';

import '../../../redux/models/app_state.dart';
import '../../../redux/models/music_item.dart';
import '../../../redux/models/search_state.dart';
import '../actions/music_actions.dart';

class MusicGridTile extends StatelessWidget {
  final MusicItem selectedMusic;
  const MusicGridTile({
    Key? key,
    required this.selectedMusic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return StreamBuilder<bool>(
          stream: snapshot.playingStream,
          builder: (context, isPlayingSnapshot) {
            if (isPlayingSnapshot.hasError || !isPlayingSnapshot.hasData) {
              return const SizedBox.shrink();
            }
            return StreamBuilder<ProcessingState>(
                stream: snapshot.processingStateStream,
                builder: (context, processingSnapshot) {
                  if (!processingSnapshot.hasData ||
                      processingSnapshot.hasError) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () async {
                      if (isPlayingSnapshot.data! &&
                          selectedMusic.musicId ==
                              snapshot.currentMusic?.musicId) {
                        snapshot.pauseMusic();
                      } else if (selectedMusic.musicId !=
                          snapshot.currentMusic?.musicId) {
                        snapshot.playMusic(selectedMusic);
                      } else {
                        snapshot.resumeMusic();
                      }
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              children: [
                                Image.network(
                                  selectedMusic.imageUrl,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 400),
                                  right: isPlayingSnapshot.data! &&
                                          snapshot.currentMusic?.musicId ==
                                              selectedMusic.musicId
                                      ? 35
                                      : 10,
                                  bottom: isPlayingSnapshot.data! &&
                                          snapshot.currentMusic?.musicId ==
                                              selectedMusic.musicId
                                      ? 35
                                      : 10,
                                  child: AnimatedContainer(
                                    curve: Curves.fastOutSlowIn,
                                    duration: const Duration(milliseconds: 800),
                                    height: isPlayingSnapshot.data! &&
                                            snapshot.currentMusic?.musicId ==
                                                selectedMusic.musicId
                                        ? 50
                                        : 30,
                                    width: isPlayingSnapshot.data! &&
                                            snapshot.currentMusic?.musicId ==
                                                selectedMusic.musicId
                                        ? 50
                                        : 30,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: snapshot.currentMusic?.musicId ==
                                              selectedMusic.musicId
                                          ? snapshot.musicItemMetaDataLoadingState ==
                                                  LoadingState.loading
                                              ? LoadingIndicator.small(context)
                                              : MusicPlayingWaveWidget(
                                                  playingStream:
                                                      snapshot.playingStream)
                                          : const Icon(
                                              CupertinoIcons.play_circle),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            selectedMusic.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).primaryColorLight,
                                ),
                            maxLines: 2,
                          ),
                          Text(
                            selectedMusic.author,
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      color: Theme.of(context).backgroundColor,
                                      fontSize: 10,
                                    ),
                            maxLines: 1,
                          ),
                          Text(selectedMusic.duration),
                        ],
                      ),
                    ),
                  );
                });
          },
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final MusicItem? currentMusic;
  final Future<void> Function(MusicItem) playMusic;
  final Stream<ProcessingState> processingStateStream;
  final Stream<bool> playingStream;
  final LoadingState musicItemMetaDataLoadingState;
  final void Function() pauseMusic;
  final void Function() resumeMusic;

  _ViewModel({
    this.currentMusic,
    required this.playMusic,
    required this.musicItemMetaDataLoadingState,
    required this.processingStateStream,
    required this.playingStream,
    required this.pauseMusic,
    required this.resumeMusic,
  }) : super(equals: [
          currentMusic,
          processingStateStream,
          musicItemMetaDataLoadingState
        ]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.currentMusic == currentMusic &&
        other.playMusic == playMusic &&
        other.processingStateStream == processingStateStream &&
        other.playingStream == playingStream &&
        other.musicItemMetaDataLoadingState == musicItemMetaDataLoadingState &&
        other.pauseMusic == pauseMusic;
  }

  @override
  int get hashCode {
    return currentMusic.hashCode ^
        playMusic.hashCode ^
        processingStateStream.hashCode ^
        playingStream.hashCode ^
        musicItemMetaDataLoadingState.hashCode ^
        pauseMusic.hashCode;
  }
}

class _Factory extends VmFactory<AppState, MusicGridTile> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      resumeMusic: () {
        state.audioPlayerState.audioPlayer.play();
      },
      pauseMusic: () {
        state.audioPlayerState.audioPlayer.pause();
      },
      musicItemMetaDataLoadingState:
          state.audioPlayerState.musicItemMetaDataLoadingState,
      playingStream: state.audioPlayerState.audioPlayer.playingStream,
      processingStateStream:
          state.audioPlayerState.audioPlayer.processingStateStream,
      playMusic: (mediaItem) async {
        await dispatch(
          PlayAudioAction(musicItem: mediaItem),
        );
      },
      currentMusic: state.audioPlayerState.selectedMusic,
    );
  }
}
