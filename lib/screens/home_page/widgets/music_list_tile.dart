import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/audio_player_state.dart';
import 'package:music_player/screens/home_page/actions/music_actions.dart';
import 'package:music_player/utils/loading_indicator.dart';
import 'package:music_player/utils/music_playing_wave_widget.dart';

class MusicListTile extends StatelessWidget {
  final MediaItem selectedMusic;
  const MusicListTile({
    Key? key,
    required this.selectedMusic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () async {
            await snapshot.playMusic(selectedMusic);
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
                        selectedMusic.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        selectedMusic.artist ?? 'Unknown',
                        style: Theme.of(context).textTheme.overline?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: _MusicTileTrailingWidget(
                      audioPlayerStatus: snapshot.audioPlayerStatus),
                )
              ],
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
    required this.audioPlayerStatus,
  }) : super(key: key);
  final AudioPlayerStatus audioPlayerStatus;

  @override
  Widget build(BuildContext context) {
    if (audioPlayerStatus == AudioPlayerStatus.playing) {
      return MusicPlayingWaveWidget();
    } else if (audioPlayerStatus == AudioPlayerStatus.loading) {
      return LoadingIndicator.small(context);
    } else {
      return _PlayButtonWidget();
    }
  }
}

class _ViewModel extends Vm {
  final MediaItem? currentMusic;
  final Future<void> Function(MediaItem) playMusic;
  final AudioPlayerStatus audioPlayerStatus;
  _ViewModel({
    this.currentMusic,
    required this.playMusic,
    required this.audioPlayerStatus,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ViewModel &&
        other.currentMusic == currentMusic &&
        other.playMusic == playMusic &&
        other.audioPlayerStatus == audioPlayerStatus;
  }

  @override
  int get hashCode =>
      currentMusic.hashCode ^ playMusic.hashCode ^ audioPlayerStatus.hashCode;

  _ViewModel copyWith({
    MediaItem? currentMusic,
    Future<void> Function(MediaItem)? playMusic,
    AudioPlayerStatus? audioPlayerStatus,
  }) {
    return _ViewModel(
      currentMusic: currentMusic ?? this.currentMusic,
      playMusic: playMusic ?? this.playMusic,
      audioPlayerStatus: audioPlayerStatus ?? this.audioPlayerStatus,
    );
  }

  @override
  String toString() =>
      '_ViewModel(currentMusic: $currentMusic, playMusic: $playMusic, audioPlayerStatus: $audioPlayerStatus)';
}

class _Factory extends VmFactory<AppState, MusicListTile> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      audioPlayerStatus: state.audioPlayerState.audioPlayerStatus,
      playMusic: (mediaItem) async {
        await dispatch(
          PlayAudioAction(mediaItem: mediaItem),
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
