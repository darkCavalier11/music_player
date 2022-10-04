// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/screens/playlist_screen/widgets/playlist_item_tile.dart';
import 'package:music_player/utils/app_db.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
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
                FutureBuilder<String?>(
                  future: AppDatabse.getQuery(DbKeys.playlistItem),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) {
                      return const SizedBox.shrink();
                    }
                    final playlistItems = (jsonDecode(snapshot.data!) as List)
                        .map((e) => UserPlaylistListItem.fromJson(e))
                        .toList();
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, idx) {
                          return PlaylistItemTile(
                            userPlaylist: playlistItems[idx],
                          );
                        },
                        itemCount: playlistItems.length,
                      ),
                    );
                  }),
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
  final Future<List<UserPlaylistListItem>> Function() userPlaylistListItems;
  _ViewModel({
    required this.userPlaylistListItems,
  });
}

class _Factory extends VmFactory<AppState, PlaylistScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(userPlaylistListItems: () async {
      final playlistString = await AppDatabse.getQuery(DbKeys.playlistItem);
      if (playlistString == null) {
        return [];
      }
      return (jsonDecode(playlistString) as List)
          .map((e) => UserPlaylistListItem.fromJson(e))
          .toList();
    });
  }
}
