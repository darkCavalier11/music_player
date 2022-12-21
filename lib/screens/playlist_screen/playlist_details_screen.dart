// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/screens/home_screen/widgets/music_list_tile.dart';
import 'package:music_player/widgets/app_primary_button.dart';

import 'actions/playlist_actions.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final String userPlaylistListId;
  const PlaylistDetailsScreen({Key? key, required this.userPlaylistListId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      onDispose: (store) {
        store.dispatch(
          SetMusicPlaylistEditState(onEditState: false),
        );
      },
      builder: (context, snapshot) {
        final userPlaylistListItem =
            snapshot.getUserPlaylistItemFromId(userPlaylistListId);
        if (userPlaylistListItem.musicItems.isEmpty) {
          return const SizedBox.shrink();
        }
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 64),
                child: FutureBuilder<PaletteGenerator>(
                  future: PaletteGenerator.fromImageProvider(
                    NetworkImage(
                      userPlaylistListItem.musicItems.first.imageUrl,
                    ),
                  ),
                  builder: (context, paletteSnapshot) {
                    if (!paletteSnapshot.hasData || paletteSnapshot.hasError) {
                      return const SizedBox.shrink();
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Stack(
                          children: [
                            Image.network(
                              userPlaylistListItem.musicItems.first.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 50,
                                sigmaY: 0,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.1),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    paletteSnapshot
                                            .data!.lightVibrantColor?.color ??
                                        Colors.white,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userPlaylistListItem.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.7,
                                          color: paletteSnapshot.data!
                                                  .darkVibrantColor?.color ??
                                              Theme.of(context).canvasColor,
                                        ),
                                  ),
                                  Text(
                                    '${userPlaylistListItem.musicItems.length} Songs',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          color: paletteSnapshot.data!
                                                  .darkMutedColor?.color ??
                                              Theme.of(context).cardColor,
                                        ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.time,
                                        color: paletteSnapshot
                                                .data!.darkMutedColor?.color ??
                                            Theme.of(context).cardColor,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        userPlaylistListItem
                                            .getFormattedDuration,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              fontSize: 12,
                                              color: paletteSnapshot.data!
                                                      .darkMutedColor?.color ??
                                                  Theme.of(context).cardColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: 10,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child:
                                      const Icon(Icons.arrow_back_ios_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Spacer(),
                    AppPrimaryButton(
                      buttonText: 'Play all',
                      trailingIcon: CupertinoIcons.play_circle,
                      onTap: () {},
                    ),
                    const SizedBox(width: 4),
                    AppPrimaryButton(
                      onTap: () {},
                      buttonText: 'Shuffle Play',
                      trailingIcon: CupertinoIcons.shuffle,
                    ),
                    const SizedBox(width: 4),
                    AppPrimaryButton(
                      onTap: () {
                        snapshot
                            .setMusicPlaylistEditState(!snapshot.onEditState);
                      },
                      trailingIcon:
                          snapshot.onEditState ? Icons.done : Iconsax.edit,
                    ),
                  ],
                ),
              ),
              MusicEditListTile(
                userPlaylistListItem: userPlaylistListItem,
                onEditState: snapshot.onEditState,
                onTapRemove: (
                    {required String musicId,
                    required String playlistTitle}) async {
                  if (userPlaylistListItem.musicItems.length == 1) {
                    Navigator.of(context).pop();
                  }
                  snapshot.removeMusicItemFromPlaylist(
                      musicId: musicId, playlistTitle: playlistTitle);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class MusicEditListTile extends StatefulWidget {
  final bool onEditState;
  final Future<void> Function(
      {required String playlistTitle, required String musicId}) onTapRemove;
  const MusicEditListTile({
    Key? key,
    required this.userPlaylistListItem,
    required this.onEditState,
    required this.onTapRemove,
  }) : super(key: key);

  final UserPlaylistListItem userPlaylistListItem;

  @override
  State<MusicEditListTile> createState() => _MusicEditListTileState();
}

class _MusicEditListTileState extends State<MusicEditListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, idx) {
          return Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: () {
                    widget.onTapRemove(
                      musicId:
                          widget.userPlaylistListItem.musicItems[idx].musicId,
                      playlistTitle: widget.userPlaylistListItem.title,
                    );
                  },
                  child: Icon(
                    CupertinoIcons.minus_circle_fill,
                    key: Key(
                      widget.onEditState.toString(),
                    ),
                    size: widget.onEditState ? 18 : 0,
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                child: MusicListTile(
                  selectedMusic: widget.userPlaylistListItem.musicItems[idx],
                  disabled: widget.onEditState,
                ),
                builder: (context, child) {
                  return Expanded(
                    child: Transform.rotate(
                      angle: widget.onEditState
                          ? pi * _animationController.value / 150
                          : 0,
                      child: child,
                    ),
                  );
                },
              ),
            ],
          );
        },
        itemCount: widget.userPlaylistListItem.musicItems.length,
      ),
    );
  }
}

class _ViewModel extends Vm {
  final void Function(String) removePlaylist;
  final bool onEditState;
  final void Function(bool) setMusicPlaylistEditState;
  final UserPlaylistListItem Function(String) getUserPlaylistItemFromId;
  final Future<void> Function(
      {required String playlistTitle,
      required String musicId}) removeMusicItemFromPlaylist;
  _ViewModel({
    required this.removePlaylist,
    required this.onEditState,
    required this.setMusicPlaylistEditState,
    required this.removeMusicItemFromPlaylist,
    required this.getUserPlaylistItemFromId,
  });
}

class _Factory extends VmFactory<AppState, PlaylistDetailsScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      getUserPlaylistItemFromId: (id) {
        return state.userPlaylistState.userPlaylistItems.firstWhere(
          (element) => element.id == id,
          orElse: () {
            return UserPlaylistListItem(
              id: '',
              title: '',
              musicItems: [],
            );
          },
        );
      },
      removePlaylist: (playlistId) {
        dispatch(RemovePlaylistById(playlistId: playlistId));
      },
      onEditState: state.userPlaylistState.onEditState,
      setMusicPlaylistEditState: (onEditState) {
        dispatch(
          SetMusicPlaylistEditState(onEditState: onEditState),
        );
      },
      removeMusicItemFromPlaylist: (
          {required String playlistTitle, required String musicId}) async {
        dispatch(RemoveMusicItemFromPlaylist(
            playlistTitle: playlistTitle, musicId: musicId));
      },
    );
  }
}
