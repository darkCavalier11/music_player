import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/widgets/loading_indicator.dart';
import 'package:music_player/widgets/music_playing_wave_widget.dart';

import '../../../redux/models/app_state.dart';
import '../../../redux/models/music_item.dart';
import '../../../redux/models/search_state.dart';
import '../actions/music_actions.dart';
import 'music_item_selected_screen.dart';

class MusicGridTile extends StatefulWidget {
  final MusicItem selectedMusic;
  // if this is a secondary musictile then long tap will be disabled
  final bool? isSecondary;
  // if the current music item is not a part of current playlist, should be cleared
  final bool? clearEarlierPlaylist;
  const MusicGridTile({
    Key? key,
    this.isSecondary,
    required this.selectedMusic,
    this.clearEarlierPlaylist,
  }) : super(key: key);

  @override
  State<MusicGridTile> createState() => _MusicGridTileState();
}

class _MusicGridTileState extends State<MusicGridTile> {
  late GlobalKey _key;
  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return StreamBuilder<bool>(
          key: _key,
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
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onLongPress: widget.isSecondary == null
                        ? null
                        : () async {
                            RenderBox box = _key.currentContext
                                ?.findRenderObject() as RenderBox;
                            await Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (context, _, __) {
                                  final _offset =
                                      box.localToGlobal(Offset.zero);
                                  return MusicItemSelectedScreen(
                                    musicItemTileType: MusicItemTileType.grid,
                                    musicItem: widget.selectedMusic,
                                    offset: _offset.dy < 0
                                        ? Offset(_offset.dx, 50)
                                        : _offset,
                                  );
                                },
                              ),
                            );
                          },
                    onTap: () async {
                      if (isPlayingSnapshot.data! &&
                          widget.selectedMusic.musicId ==
                              snapshot.currentMusic?.musicId) {
                        snapshot.pauseMusic();
                      } else if (widget.selectedMusic.musicId !=
                          snapshot.currentMusic?.musicId) {
                        snapshot.playMusic(
                          widget.selectedMusic,
                        );
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
                                CachedNetworkImage(
                                  imageUrl: widget.selectedMusic.imageUrl,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 400),
                                  right: isPlayingSnapshot.data! &&
                                          processingSnapshot.data ==
                                              ProcessingState.ready &&
                                          snapshot.currentMusic?.musicId ==
                                              widget.selectedMusic.musicId
                                      ? 35
                                      : 10,
                                  bottom: isPlayingSnapshot.data! &&
                                          processingSnapshot.data ==
                                              ProcessingState.ready &&
                                          snapshot.currentMusic?.musicId ==
                                              widget.selectedMusic.musicId
                                      ? 35
                                      : 10,
                                  child: AnimatedContainer(
                                    curve: Curves.fastOutSlowIn,
                                    duration: const Duration(milliseconds: 800),
                                    height: isPlayingSnapshot.data! &&
                                            processingSnapshot.data ==
                                                ProcessingState.ready &&
                                            snapshot.currentMusic?.musicId ==
                                                widget.selectedMusic.musicId
                                        ? 50
                                        : 30,
                                    width: isPlayingSnapshot.data! &&
                                            processingSnapshot.data ==
                                                ProcessingState.ready &&
                                            snapshot.currentMusic?.musicId ==
                                                widget.selectedMusic.musicId
                                        ? 50
                                        : 30,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: snapshot.currentMusic?.musicId ==
                                                  widget
                                                      .selectedMusic.musicId &&
                                              processingSnapshot.data! !=
                                                  ProcessingState.completed
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
                            widget.selectedMusic.title,
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
                            widget.selectedMusic.author,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontSize: 10,
                                ),
                            maxLines: 1,
                          ),
                          Text(
                            widget.selectedMusic.duration,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                          ),
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

class _Factory extends VmFactory<AppState, _MusicGridTileState> {
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
          PlayAudioAction(
            musicItem: mediaItem,
          ),
        );
      },
      currentMusic: state.audioPlayerState.selectedMusic,
    );
  }
}
