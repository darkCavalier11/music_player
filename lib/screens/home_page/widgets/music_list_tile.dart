import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_model.dart';
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
            final audioUri = AudioSource.uri(
              selectedMusic.artUri ?? Uri(),
              tag: selectedMusic,
            );
            await snapshot.audioPlayer.setAudioSource(audioUri);
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            // fontWeight: FontWeight.bold,
                            ),
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
  _ViewModel({required this.audioPlayer, required this.currentMusic});
}

class _Factory extends VmFactory<AppState, MusicListTile> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      audioPlayer: state.uiState.audioPlayerState.audioPlayer,
      currentMusic: state.uiState.audioPlayerState.selectedMusic,
    );
  }
}

class _PlayButtonWidget extends StatefulWidget {
  const _PlayButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_PlayButtonWidget> createState() => _PlayButtonWidgetState();
}

class _PlayButtonWidgetState extends State<_PlayButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          _animationController.status;
        },
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.play_arrow,
              size: 18,
            ),
            AnimatedBuilder(
              builder: (context, child) {
                return SizedBox(width: _animation.value * 10);
              },
              animation: _animation,
            ),
            Text(
              '3:37',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
