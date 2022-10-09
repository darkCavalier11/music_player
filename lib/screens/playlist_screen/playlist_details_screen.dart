// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/screens/home_screen/widgets/music_list_tile.dart';
import 'package:music_player/widgets/app_primary_button.dart';
import 'package:palette_generator/palette_generator.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final UserPlaylistListItem userPlaylistListItem;
  const PlaylistDetailsScreen({Key? key, required this.userPlaylistListItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                      // fontFamily: 'Courgette',
                                      color: paletteSnapshot
                                              .data!.darkVibrantColor?.color ??
                                          Theme.of(context).canvasColor,
                                    ),
                              ),
                              Text(
                                '4 Songs',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 12,
                                      color: paletteSnapshot
                                              .data!.darkMutedColor?.color ??
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
                                    '01:26:00',
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
                              child: const Icon(Icons.arrow_back_ios_rounded),
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
                  trailingIcon: CupertinoIcons.delete,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, idx) {
                return MusicListTile(
                  selectedMusic: userPlaylistListItem.musicItems[idx],
                );
              },
              itemCount: userPlaylistListItem.musicItems.length,
            ),
          )
        ],
      ),
    );
  }
}

class _ViewModel extends Vm {
  final List<UserPlaylistListItem> userPlaylistItems;
  _ViewModel({
    required this.userPlaylistItems,
  });
}

class _Factory extends VmFactory<AppState, PlaylistDetailsScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      userPlaylistItems: state.userPlaylistState.userPlaylistItems,
    );
  }
}
