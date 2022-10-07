// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/user_playlist_list_item.dart';
import 'package:music_player/widgets/app_primary_button.dart';
import 'package:music_player/widgets/app_text_field.dart';

class SelectMusicAddMusicScreen extends StatefulWidget {
  const SelectMusicAddMusicScreen({Key? key}) : super(key: key);

  @override
  State<SelectMusicAddMusicScreen> createState() =>
      _SelectMusicAddMusicScreenState();
}

class _SelectMusicAddMusicScreenState extends State<SelectMusicAddMusicScreen> {
  List<int> _selectedTileIndexes = [];
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Select Playlist to Add',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 20,
                                    color: Theme.of(context).disabledColor,
                                  ),
                        ),
                      ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 8, right: 8),
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) => ListTile(
                                    title: Text('Hello'),
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
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                  ),
                                  itemCount: 10,
                                ),
                              ),
                            ),
                            if (_selectedTileIndexes.isNotEmpty)
                              Row(
                                children: [
                                  const Spacer(),
                                  AppPrimaryButton(
                                    buttonText: 'Done',
                                    onTap: () {},
                                    trailingIcon: Icons.done,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
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
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                onSubmitted: (text) {},
                                hintText: 'Create playlist and add...',
                              ),
                            ),
                            AppPrimaryButton(
                              buttonText: 'Add',
                              onTap: () {},
                              trailingIcon: CupertinoIcons.add,
                            )
                          ],
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
  _ViewModel({
    required this.userPlaylistItems,
  });
}

class _Factory extends VmFactory<AppState, _SelectMusicAddMusicScreenState> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      userPlaylistItems: state.userPlaylistState.userPlaylistItems,
    );
  }
}
