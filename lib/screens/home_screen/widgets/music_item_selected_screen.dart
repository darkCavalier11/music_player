// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/screens/app_page_view.dart';
import 'package:music_player/screens/home_screen/widgets/music_list_tile.dart';
import 'package:music_player/widgets/app_primary_button.dart';

import '../../../redux/models/music_item.dart';
import '../../playlist_screen/actions/playlist_actions.dart';

class MusicItemSelectedScreen extends StatefulWidget {
  static const routeName = '/musicItemSelectedScreen';
  final MusicItem musicItem;
  const MusicItemSelectedScreen({
    Key? key,
    required this.musicItem,
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
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 25,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MusicListTile(
                          selectedMusic: widget.musicItem,
                        ),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _animationController.value,
                              child: Transform.translate(
                                offset: Offset(
                                    0, (1 - _animationController.value) * 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      splashColor:
                                          Colors.redAccent.withOpacity(0.2),
                                      onPressed: () {
                                        if (_isMusicItemInFav) {
                                          snapshot.removeMusicItemFromPlaylist(
                                              widget.musicItem, 'Favourite');
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
                                    const AppPrimaryButton(
                                      buttonText: 'Add To Playlist',
                                      trailingIcon: Icon(
                                        Iconsax.music_playlist,
                                        size: 18,
                                      ),
                                    ),
                                    const AppPrimaryButton(
                                      buttonText: 'Show next',
                                      trailingIcon: Icon(
                                        CupertinoIcons.list_bullet,
                                        size: 18,
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
  _ViewModel({
    required this.addMusicItemToPlaylist,
    required this.removeMusicItemFromPlaylist,
    required this.isMusicItemInFav,
  });
}

class _Factory extends VmFactory<AppState, _MusicItemSelectedScreenState> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      removeMusicItemFromPlaylist: (musicitem, playlistName) {
        dispatch(RemoveMusicItemFromPlaylist(
            title: playlistName, musicItem: musicitem));
      },
      isMusicItemInFav: (musicItem) {
        final userPlaylistListItems = state.userPlaylistState.userPlaylistItems;
        for (var playlist in userPlaylistListItems) {
          if (playlist.musicItems.indexWhere(
                  (element) => element.musicId == musicItem.musicId) !=
              -1) {
            return true;
          }
        }
        return false;
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
