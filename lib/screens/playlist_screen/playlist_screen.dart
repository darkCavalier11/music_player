// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/download_state.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/screens/playlist_screen/actions/playlist_actions.dart';
import 'package:music_player/screens/playlist_screen/download_in_progress_screen.dart';
import 'package:music_player/screens/playlist_screen/widgets/playlist_item_tile.dart';
import 'package:music_player/widgets/app_dialog.dart';
import 'package:music_player/widgets/app_primary_button.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      onInit: (store) {
        store.dispatch(LoadUserPlaylistAction());
      },
      builder: (context, snapshot) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 64),
                Row(
                  children: [
                    Icon(
                      Iconsax.music_playlist,
                      size: 35,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'My Playlist',
                      style: Theme.of(context).textTheme.button?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DownloadInProgressScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.arrow_down_circle),
                        const SizedBox(width: 4),
                        Text(
                          'Downloads (${snapshot.musicItemDownloadList.length} in progress)',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, idx) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          return AppUiUtils.appGenericDialog<bool>(
                            context,
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Do you want to remove playlist ',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  TextSpan(
                                    text: snapshot
                                        .userPlaylistListItems[idx].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const TextSpan(text: '?'),
                                ],
                              ),
                            ),
                            actions: Row(
                              children: [
                                const Spacer(),
                                AppPrimaryButton(
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  buttonText: 'Cancel',
                                ),
                                AppPrimaryButton(
                                  onTap: () {
                                    snapshot.removePlaylist(
                                        snapshot.userPlaylistListItems[idx].id);
                                    Navigator.of(context).pop(true);
                                  },
                                  buttonText: 'Remove',
                                ),
                              ],
                            ),
                          );
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(
                                  CupertinoIcons.delete,
                                ),
                              ),
                            ],
                          ),
                        ),
                        key: ValueKey(snapshot.userPlaylistListItems[idx].id),
                        child: PlaylistItemTile(
                          userPlaylist: snapshot.userPlaylistListItems[idx],
                        ),
                      );
                    },
                    itemCount: snapshot.userPlaylistListItems.length,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final List<UserPlaylistListItem> userPlaylistListItems;
  final void Function(String) removePlaylist;
  final List<MusicItemForDownload> musicItemDownloadList;
  _ViewModel({
    required this.userPlaylistListItems,
    required this.removePlaylist,
    required this.musicItemDownloadList,
  }) : super(equals: [
          userPlaylistListItems,
          musicItemDownloadList,
        ]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.userPlaylistListItems, userPlaylistListItems) &&
        other.removePlaylist == removePlaylist &&
        listEquals(other.musicItemDownloadList, musicItemDownloadList);
  }

  @override
  int get hashCode =>
      userPlaylistListItems.hashCode ^
      removePlaylist.hashCode ^
      musicItemDownloadList.hashCode;
}

class _Factory extends VmFactory<AppState, PlaylistScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      userPlaylistListItems: state.userPlaylistState.userPlaylistItems,
      removePlaylist: (playlistId) {
        dispatch(RemovePlaylistById(playlistId: playlistId));
      },
      musicItemDownloadList: state.downloadState.musicItemDownloadList,
    );
  }
}
