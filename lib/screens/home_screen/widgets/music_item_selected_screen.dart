// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/download_state.dart';
import 'package:music_player/screens/home_screen/actions/download_actions.dart';
import 'package:music_player/screens/home_screen/widgets/music_grid_tile.dart';
import 'package:music_player/screens/home_screen/widgets/music_list_tile.dart';
import 'package:music_player/screens/home_screen/widgets/select_playlist_add_music_screen.dart';
import 'package:music_player/utils/api_request.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/yt_parser/lib/parser_helper.dart';
import 'package:music_player/widgets/app_primary_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../redux/models/music_item.dart';
import '../../playlist_screen/actions/playlist_actions.dart';

class MusicItemSelectedScreen extends StatefulWidget {
  static const routeName = '/musicItemSelectedScreen';
  final MusicItem musicItem;
  final Offset offset;
  final MusicItemTileType musicItemTileType;
  const MusicItemSelectedScreen({
    Key? key,
    required this.musicItem,
    required this.offset,
    required this.musicItemTileType,
  }) : super(key: key);

  @override
  State<MusicItemSelectedScreen> createState() =>
      _MusicItemSelectedScreenState();
}

class _MusicItemSelectedScreenState extends State<MusicItemSelectedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        final bool _isMusicItemInFav =
            snapshot.isMusicItemInFav(widget.musicItem);
        return WillPopScope(
          onWillPop: () async {
            _animationController.reverse();
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 25,
                          sigmaY: 35,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).canvasColor.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: widget.offset.dy),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TweenAnimationBuilder<double>(
                                curve: Curves.elasticOut,
                                duration: const Duration(milliseconds: 800),
                                tween: Tween<double>(begin: 0, end: 18),
                                child: widget.musicItemTileType ==
                                        MusicItemTileType.grid
                                    ? MusicGridTile(
                                        selectedMusic: widget.musicItem,
                                        isSecondary: true,
                                      )
                                    : MusicListTile(
                                        selectedMusic: widget.musicItem,
                                        isSecondary: true,
                                      ),
                                builder: (context, value, child) => Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: widget.musicItemTileType ==
                                              MusicItemTileType.list
                                          ? value
                                          : 0,
                                      vertical: widget.musicItemTileType ==
                                              MusicItemTileType.grid
                                          ? value
                                          : 0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).dividerColor,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: child,
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _animationController.value,
                                    child: Transform.translate(
                                      offset: Offset(
                                          0,
                                          (1 - _animationController.value) *
                                              20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            padding: const EdgeInsets.all(0),
                                            splashColor: Colors.redAccent
                                                .withOpacity(0.2),
                                            onPressed: () {
                                              if (_isMusicItemInFav) {
                                                snapshot
                                                    .removeMusicItemFromPlaylist(
                                                        widget.musicItem,
                                                        'Favourite');
                                              } else {
                                                snapshot.addMusicItemToPlaylist(
                                                  widget.musicItem,
                                                  'Favourite',
                                                );
                                              }
                                            },
                                            icon: Icon(
                                              _isMusicItemInFav
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
                                              color: Colors.redAccent,
                                              size: _isMusicItemInFav ? 30 : 24,
                                            ),
                                          ),
                                          AppPrimaryButton(
                                            buttonText: 'Add To Playlist',
                                            trailingIcon:
                                                Iconsax.music_playlist,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  opaque: false,
                                                  pageBuilder: (context, _,
                                                          __) =>
                                                      SelectMusicAddMusicScreen(
                                                          musicItem:
                                                              widget.musicItem),
                                                ),
                                              );
                                              // Navigator.of(context).pop;
                                            },
                                          ),
                                          IconButton(
                                            padding: const EdgeInsets.all(0),
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () async {
                                              try {
                                                final per = await Permission
                                                    .storage
                                                    .request();
                                                if (per.isGranted) {
                                                  final musicUrl =
                                                      await ParserHelper
                                                          .getMusicItemUrl(
                                                              widget.musicItem
                                                                  .musicId);
                                                  final savePath =
                                                      await FilePicker.platform
                                                          .getDirectoryPath();

                                                  if (savePath != null) {
                                                    final file = File(savePath +
                                                        '/music.m4a');
                                                    file.createSync();
                                                    snapshot
                                                        .addMusicItemToDownloadList(
                                                            widget.musicItem
                                                                .musicId);
                                                    ApiRequest.download(
                                                      uri: musicUrl,
                                                      savePath: savePath +
                                                          '/${widget.musicItem.title}.m4a',
                                                      onReceiveProgress:
                                                          (count, total) {
                                                        snapshot
                                                            .updateDownloadProgressForMusicItem(
                                                                widget.musicItem
                                                                    .musicId,
                                                                count / total);
                                                      },
                                                    );
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Downloading music item...');
                                                  }
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Please enable storage access');
                                                }
                                              } catch (err) {
                                                log('$err');
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Unable to download music item');
                                              }
                                            },
                                            icon: snapshot
                                                        .getMusicItemDownloadState(
                                                            widget.musicItem
                                                                .musicId)
                                                        ?.downloadStatus ==
                                                    DownloadStatus.progress
                                                ? Transform.scale(
                                                    scale: 0.8,
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .dividerColor,
                                                      value: snapshot
                                                          .getMusicItemDownloadState(
                                                              widget.musicItem
                                                                  .musicId)
                                                          ?.progress,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Icon(
                                                    CupertinoIcons.arrow_down,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final void Function(MusicItem, String playlistName) addMusicItemToPlaylist;
  final void Function(MusicItem, String playlistName)
      removeMusicItemFromPlaylist;
  final bool Function(MusicItem) isMusicItemInFav;
  final void Function(String) addMusicItemToDownloadList;
  final void Function(String, double) updateDownloadProgressForMusicItem;
  final void Function(String) cancelDownloadForMusicItem;
  final MusicItemForDownload? Function(String) getMusicItemDownloadState;
  _ViewModel({
    required this.addMusicItemToPlaylist,
    required this.removeMusicItemFromPlaylist,
    required this.isMusicItemInFav,
    required this.addMusicItemToDownloadList,
    required this.updateDownloadProgressForMusicItem,
    required this.cancelDownloadForMusicItem,
    required this.getMusicItemDownloadState,
  });
}

class _Factory extends VmFactory<AppState, _MusicItemSelectedScreenState> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      getMusicItemDownloadState: (musicId) {
        final idx = state.downloadState.musicItemDownloadList
            .indexWhere((element) => element.musicId == musicId);
        if (idx != -1) {
          return state.downloadState.musicItemDownloadList
              .firstWhere((element) => element.musicId == musicId);
        }
      },
      cancelDownloadForMusicItem: (musicId) {
        dispatch(CancelDownloadForMusicItem(musicId: musicId));
      },
      updateDownloadProgressForMusicItem: (musicId, progress) {
        dispatch(UpdateMusicItemDownloadProgress(
            musicId: musicId, progress: progress));
      },
      addMusicItemToDownloadList: (musicId) {
        dispatch(AddMusicItemToDownload(musicId: musicId));
      },
      removeMusicItemFromPlaylist: (musicitem, playlistName) {
        dispatch(
          RemoveMusicItemFromPlaylist(
            playlistTitle: playlistName,
            musicId: musicitem.musicId,
          ),
        );
      },
      isMusicItemInFav: (musicItem) {
        final _index = state.userPlaylistState.userPlaylistItems.indexWhere(
          (element) => element.title == 'Favourite',
        );
        if (_index == -1) {
          return false;
        }
        return state.userPlaylistState.userPlaylistItems[_index].musicItems
                .indexWhere(
                    (element) => element.musicId == musicItem.musicId) !=
            -1;
      },
      addMusicItemToPlaylist: (musicItem, playlistName) {
        dispatch(
          AddMusicItemtoPlaylist(
            musicItem: musicItem,
            playlistName: playlistName,
          ),
        );
      },
    );
  }
}
