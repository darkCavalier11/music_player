// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/screens/playlist_screen/actions/playlist_actions.dart';
import 'package:music_player/widgets/app_primary_button.dart';
import 'package:music_player/widgets/app_text_field.dart';

class SelectMusicAddMusicScreen extends StatefulWidget {
  final MusicItem musicItem;
  const SelectMusicAddMusicScreen({
    Key? key,
    required this.musicItem,
  }) : super(key: key);

  @override
  State<SelectMusicAddMusicScreen> createState() =>
      _SelectMusicAddMusicScreenState();
}

class _SelectMusicAddMusicScreenState extends State<SelectMusicAddMusicScreen> {
  final List<int> _selectedTileIndexes = [];
  String _playlistTextField = '';
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) => Scaffold(
        backgroundColor: Colors.transparent,
        body: WillPopScope(
          onWillPop: () async {
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
                alignment: Alignment.center,
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
                        color: Theme.of(context).canvasColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width *
                            (_selectedTileIndexes.isEmpty ? 0.8 : 0.9),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    Iconsax.music_playlist,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Positioned(
                                    right: -8,
                                    top: -5,
                                    child: Icon(
                                      CupertinoIcons.add_circled_solid,
                                      color: Theme.of(context).primaryColor,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            snapshot.userPlaylistItems.isEmpty
                                ? Column(
                                    children: [
                                      const SizedBox(height: 100),
                                      Text(
                                        'No Playlist found!, Add one below.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                      ),
                                    ],
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (context, index) => ListTile(
                                        title: Text(
                                          snapshot
                                              .userPlaylistItems[index].title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                        ),
                                        subtitle: Divider(
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.1),
                                        ),
                                        onTap: () {
                                          if (_selectedTileIndexes
                                              .contains(index)) {
                                            _selectedTileIndexes.remove(index);
                                          } else {
                                            _selectedTileIndexes.add(index);
                                          }
                                          setState(() {});
                                        },
                                        trailing: !_selectedTileIndexes
                                                .contains(index)
                                            ? const Icon(CupertinoIcons.circle)
                                            : Icon(
                                                Iconsax.tick_circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                      ),
                                      itemCount:
                                          snapshot.userPlaylistItems.length,
                                    ),
                                  ),
                            if (_selectedTileIndexes.isNotEmpty)
                              Row(
                                children: [
                                  const Spacer(),
                                  AppPrimaryButton(
                                    buttonText: 'Done',
                                    onTap: () {
                                      for (var element
                                          in _selectedTileIndexes) {
                                        snapshot.addToPlaylist(
                                          snapshot
                                              .userPlaylistItems[element].title,
                                          widget.musicItem,
                                        );
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    trailingIcon: Icons.done,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: _selectedTileIndexes.isEmpty ? 1 : 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 0.5,
                              color: Theme.of(context).primaryColor,
                            ),
                            Text(
                              'OR',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 0.5,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: _selectedTileIndexes.isEmpty ? 1 : 0,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  enabled: _selectedTileIndexes.isEmpty,
                                  onChanged: (text) {
                                    setState(() {
                                      _playlistTextField = text;
                                    });
                                  },
                                  hintText: 'Create playlist and add...',
                                ),
                              ),
                              AppPrimaryButton(
                                buttonText: 'Add',
                                onTap: () {
                                  snapshot.addToPlaylist(
                                    _playlistTextField,
                                    widget.musicItem,
                                  );
                                },
                                trailingIcon: CupertinoIcons.add,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends Vm {
  final List<UserPlaylistListItem> userPlaylistItems;
  final void Function(String, MusicItem) addToPlaylist;
  _ViewModel({
    required this.userPlaylistItems,
    required this.addToPlaylist,
  }) : super(equals: [
          userPlaylistItems,
        ]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.userPlaylistItems, userPlaylistItems) &&
        other.addToPlaylist == addToPlaylist;
  }

  @override
  int get hashCode => userPlaylistItems.hashCode ^ addToPlaylist.hashCode;
}

class _Factory extends VmFactory<AppState, _SelectMusicAddMusicScreenState> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
        userPlaylistItems: state.userPlaylistState.userPlaylistItems,
        addToPlaylist: (playlistName, musicItem) {
          dispatch(AddMusicItemtoPlaylist(
              playlistName: playlistName, musicItem: musicItem));
        });
  }
}
