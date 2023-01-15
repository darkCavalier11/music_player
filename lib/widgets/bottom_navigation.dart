// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:math' hide log;

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/download_state.dart';
import 'package:music_player/screens/music_item_controller_screen/music_item_controller_screen.dart';

import '../redux/models/music_item.dart';
import 'music_playing_small_indicator.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return StreamBuilder<ProcessingState>(
            stream: snapshot.processingStateStream,
            builder: (context, musicSnapshot) {
              if (!musicSnapshot.hasData || musicSnapshot.hasError) {
                return const SizedBox.shrink();
              }
              return Row(
                children: [
                  AnimatedContainer(
                    curve: Curves.elasticInOut,
                    duration: const Duration(seconds: 1),
                    width: MediaQuery.of(context).size.width *
                        (musicSnapshot.data != ProcessingState.idle
                            ? 0.65
                            : 0.6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).disabledColor,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              snapshot.onChange(0);
                            },
                            child: _BottomNavigationButton(
                              enabledText: 'Home',
                              icon: CupertinoIcons.home,
                              enabled: snapshot.currentBottomNavIndex == 0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              snapshot.onChange(1);
                            },
                            child: _BottomNavigationButton(
                              enabledText: 'Playlist',
                              icon: Iconsax.music_playlist,
                              enabled: snapshot.currentBottomNavIndex == 1,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              snapshot.onChange(2);
                            },
                            child: _BottomNavigationButton(
                              enabledText: 'Account',
                              icon: CupertinoIcons.person,
                              enabled: snapshot.currentBottomNavIndex == 2,
                            ),
                          ),
                          if (musicSnapshot.data! != ProcessingState.idle) ...[
                            Container(
                              width: 1,
                              height: 30,
                              color: Theme.of(context).disabledColor,
                            ),
                            const MusicPlayingSmallIndicator(),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}

class _BottomNavigationButton extends StatefulWidget {
  final IconData icon;
  final String enabledText;
  final bool enabled;
  const _BottomNavigationButton({
    Key? key,
    required this.icon,
    required this.enabledText,
    required this.enabled,
  }) : super(key: key);

  @override
  State<_BottomNavigationButton> createState() =>
      _BottomNavigationButtonState();
}

class _BottomNavigationButtonState extends State<_BottomNavigationButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: AnimatedSize(
        alignment: Alignment.topLeft,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 45,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.enabled
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : null,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.enabled
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hintColor,
              ),
              const SizedBox(width: 4),
              if (widget.enabled)
                Text(
                  widget.enabledText,
                  style: Theme.of(context).textTheme.button?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends Vm {
  final int currentBottomNavIndex;
  final void Function(int) onChange;
  final Stream<ProcessingState> processingStateStream;
  final Stream<bool> playingStream;
  final MusicItem? musicItem;
  final List<MusicItemForDownload> musicItemDownloadList;
  _ViewModel({
    required this.currentBottomNavIndex,
    required this.onChange,
    required this.processingStateStream,
    required this.playingStream,
    required this.musicItem,
    required this.musicItemDownloadList,
  }) : super(equals: [
          currentBottomNavIndex,
          processingStateStream,
          playingStream,
          musicItem,
          musicItemDownloadList,
        ]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.currentBottomNavIndex == currentBottomNavIndex &&
        other.onChange == onChange &&
        other.processingStateStream == processingStateStream &&
        other.playingStream == playingStream &&
        other.musicItem == musicItem &&
        listEquals(other.musicItemDownloadList, musicItemDownloadList);
  }

  @override
  int get hashCode {
    return currentBottomNavIndex.hashCode ^
        onChange.hashCode ^
        processingStateStream.hashCode ^
        playingStream.hashCode ^
        musicItem.hashCode ^
        musicItemDownloadList.hashCode;
  }
}

class _Factory extends VmFactory<AppState, BottomNavigationWidget> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      playingStream: state.audioPlayerState.audioPlayer.playingStream,
      musicItem: state.audioPlayerState.selectedMusic,
      currentBottomNavIndex: state.uiState.currentBottomNavIndex,
      onChange: (index) {
        dispatch(ChangeBottomNavIndex(index: index));
      },
      processingStateStream:
          state.audioPlayerState.audioPlayer.processingStateStream,
      musicItemDownloadList: state.downloadState.musicItemDownloadList,
    );
  }
}
