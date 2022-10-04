// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/screens/playlist_screen/actions/playlist_actions.dart';
import 'package:music_player/screens/playlist_screen/widgets/playlist_item_tile.dart';

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
                      'Your Playlist',
                      style: Theme.of(context).textTheme.button?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, idx) {
                      return PlaylistItemTile(
                        userPlaylist: snapshot.userPlaylistListItems[idx],
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
  _ViewModel({
    required this.userPlaylistListItems,
  }) : super(equals: [userPlaylistListItems]);
}

class _Factory extends VmFactory<AppState, PlaylistScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      userPlaylistListItems: state.userPlaylistState.userPlaylistItems,
    );
  }
}
