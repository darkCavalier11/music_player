// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
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
                PlaylistItemTile(
                  imageUrl1:
                      'https://images.unsplash.com/photo-1513010963904-2fefe6a92780?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                  imageUrl2:
                      'https://images.unsplash.com/photo-1663431261867-01399cf8847d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                  imageUrl3:
                      'https://images.unsplash.com/photo-1663475928373-12f26f48e4b4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
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
