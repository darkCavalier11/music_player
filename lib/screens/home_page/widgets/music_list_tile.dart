import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/main.dart';
import 'package:music_player/redux/models/app_state.dart';

class MusicListTile extends StatelessWidget {
  const MusicListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () async {
            final audioUri = AudioSource.uri(
              Uri.parse('https://example.com/song1.mp3'),
              tag: MediaItem(
                // Specify a unique ID for each media item:
                id: '1',
                // Metadata to display in the notification:
                album: "Album name",
                title: "Song name",
                artUri: Uri.parse('https://example.com/albumart.jpg'),
              ),
            );
            await snapshot.audioPlayer.setAudioSource(audioUri);
            snapshot.audioPlayer.playerStateStream.listen((event) {
              log(event.toString());
            });
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
                        'Dil to baccha hai ji',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Rahat Fateh Ali Khan',
                        style: Theme.of(context).textTheme.overline?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                      ),
                    ],
                  ),
                ),
                _PlayButtonWidget(),
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
  _ViewModel({required this.audioPlayer});
}

class _Factory extends VmFactory<AppState, MusicListTile> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      audioPlayer: state.uiState.audioPlayerState.audioPlayer,
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
            )
          ],
        ),
      ),
    );
  }
}
