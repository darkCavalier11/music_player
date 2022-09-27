// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/screens/home_screen/actions/music_actions.dart';
import 'package:music_player/widgets/loading_indicator.dart';
import 'package:music_player/utils/mixins.dart';
import 'package:music_player/utils/music_circular_avatar.dart';
import 'package:music_player/widgets/music_playing_wave_widget.dart';

class MusicListTile extends StatelessWidget with AppUtilityMixin {
  final MusicItem selectedMusic;
  final bool? isPlaylist;
  final void Function(MusicItem) onTap;
  const MusicListTile({
    Key? key,
    required this.selectedMusic,
    required this.onTap,
    this.isPlaylist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Material(
          color: Theme.of(context).primaryColor.withAlpha(0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                await snapshot.playMusic(selectedMusic);
              },
              child: Row(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MusicCircularAvatar(
                          imageUrl: selectedMusic.imageUrl,
                        ),
                      ),
                      if (isPlaylist ?? false)
                        const Positioned(
                          top: 15,
                          left: 15,
                          child: CircleAvatar(
                            maxRadius: 10,
                            child: Icon(
                              Icons.playlist_play,
                              size: 15,
                            ),
                          ),
                        )
                    ],
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedMusic.title,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                          maxLines: 1,
                        ),
                        Text(
                          selectedMusic.author,
                          style: Theme.of(context).textTheme.overline?.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                          maxLines: 1,
                        ),
                        if (selectedMusic.duration != null)
                          Text(selectedMusic.duration),
                      ],
                    ),
                  ),
                  snapshot.currentMusic?.musicId == selectedMusic.musicId
                  // if current music tile is to be played and the music metadata
                  // was still being fetched, show loading and after that hand it to the
                  // audio player stream to handle the rest.
                      ? snapshot.musicItemMetaDataLoadingState ==
                              LoadingState.loading
                          ? LoadingIndicator.small(context)
                          : SizedBox(
                              child: _MusicTileTrailingWidget(
                                processingStateStream:
                                    snapshot.processingStateStream,
                                playingStream: snapshot.playingStream,
                              ),
                            )
                      : const _PlayButtonWidget(),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MusicTileTrailingWidget extends StatelessWidget {
  const _MusicTileTrailingWidget({
    Key? key,
    required this.processingStateStream,
    required this.playingStream,
  }) : super(key: key);
  final Stream<ProcessingState> processingStateStream;
  final Stream<bool> playingStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProcessingState>(
      stream: processingStateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (snapshot.data == ProcessingState.ready) {
          return MusicPlayingWaveWidget(
            playingStream: playingStream,
          );
        } else if (snapshot.data == ProcessingState.loading ||
            snapshot.data == ProcessingState.buffering) {
          return LoadingIndicator.small(context);
        } else {
          return _PlayButtonWidget();
        }
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

  _ViewModel({
    this.currentMusic,
    required this.playMusic,
    required this.musicItemMetaDataLoadingState,
    required this.processingStateStream,
    required this.playingStream,
  }) : super(equals: [
          currentMusic,
          processingStateStream,
          musicItemMetaDataLoadingState
        ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ViewModel &&
        other.currentMusic == currentMusic &&
        other.playMusic == playMusic &&
        other.processingStateStream == processingStateStream &&
        other.playingStream == playingStream;
  }

  @override
  int get hashCode {
    return currentMusic.hashCode ^
        playMusic.hashCode ^
        processingStateStream.hashCode ^
        playingStream.hashCode;
  }
}

class _Factory extends VmFactory<AppState, MusicListTile> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
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

class _PlayButtonWidget extends StatelessWidget {
  const _PlayButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: const Icon(
          CupertinoIcons.play_circle,
          size: 20,
        ),
      ),
    );
  }
}
