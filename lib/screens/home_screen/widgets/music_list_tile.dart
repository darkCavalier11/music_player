// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/screens/home_screen/actions/music_actions.dart';
import 'package:music_player/screens/home_screen/widgets/music_item_selected_screen.dart';
import 'package:music_player/utils/music_circular_avatar.dart';
import 'package:music_player/widgets/loading_indicator.dart';
import 'package:music_player/widgets/music_playing_wave_widget.dart';

class MusicListTile extends StatefulWidget {
  final MusicItem selectedMusic;
  final bool? isPlaylist;
  // if this is a secondary musictile then long tap will be disabled
  final bool? isSecondary;
  const MusicListTile({
    Key? key,
    required this.selectedMusic,
    this.isPlaylist,
    this.isSecondary,
  }) : super(key: key);

  @override
  State<MusicListTile> createState() => _MusicListTileState();
}

class _MusicListTileState extends State<MusicListTile> {
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
        return Material(
          key: _key,
          color: Theme.of(context).primaryColor.withAlpha(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: StreamBuilder<bool>(
                stream: snapshot.playingStream,
                builder: (context, isPlayingSnapshot) {
                  if (isPlayingSnapshot.hasError ||
                      !isPlayingSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  return InkWell(
                    splashColor: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(18),
                    onLongPress: () {
                      RenderBox box =
                          _key.currentContext?.findRenderObject() as RenderBox;
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, _, __) =>
                              MusicItemSelectedScreen(
                            musicItem: widget.selectedMusic,
                            offset: box.localToGlobal(Offset.zero),
                          ),
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
                        snapshot.playMusic(widget.selectedMusic);
                      } else {
                        snapshot.resumeMusic();
                      }
                    },
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MusicCircularAvatar(
                                imageUrl: widget.selectedMusic.imageUrl,
                              ),
                            ),
                            if (widget.isPlaylist ?? false)
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
                                widget.selectedMusic.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                maxLines: 1,
                              ),
                              Text(
                                widget.selectedMusic.author,
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    ?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                maxLines: 1,
                              ),
                              Text(widget.selectedMusic.duration),
                            ],
                          ),
                        ),
                        snapshot.currentMusic?.musicId ==
                                widget.selectedMusic.musicId
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
                  );
                }),
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
          return const _PlayButtonWidget();
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

class _Factory extends VmFactory<AppState, _MusicListTileState> {
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
