// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/screens/playlist_screen/playlist_details_screen.dart';

class PlaylistItemTile extends StatelessWidget {
  final UserPlaylistListItem userPlaylist;

  const PlaylistItemTile({
    Key? key,
    required this.userPlaylist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistDetailsScreen(
              userPlaylistListItem: userPlaylist,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Stack(
                children: [
                  if (userPlaylist.musicItems.length > 2)
                    Positioned(
                      left: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).disabledColor,
                            BlendMode.modulate,
                          ),
                          child: Image.network(
                            userPlaylist.musicItems[2].imageUrl,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  if (userPlaylist.musicItems.length > 1)
                    Positioned(
                      left: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).hintColor,
                            BlendMode.modulate,
                          ),
                          child: Image(
                            image: CachedNetworkImageProvider(
                                userPlaylist.musicItems[1].imageUrl),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                          image: CachedNetworkImageProvider(
                              userPlaylist.musicItems.first.imageUrl),
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.play_arrow_solid,
                        size: 12,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // todo : edit playlist name
                  Text(
                    userPlaylist.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                  Text(
                    '${userPlaylist.musicItems.length} ' +
                        (userPlaylist.musicItems.length > 1 ? 'Songs' : 'Song'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                  Text(
                    userPlaylist.getPlaylistAuthorSubtitle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
