// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/widgets/loading_indicator.dart';

import '../home_screen/actions/music_actions.dart';
import '../home_screen/home_screen.dart';
import '../home_screen/widgets/music_list_tile.dart';
import '../music_search_screen/music_search_screen.dart';

class MusicSearchResultScreen extends StatelessWidget {
  static const routeName = '/musicSearchResultScreen';
  const MusicSearchResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Scaffold(
          body: snapshot.searchResultFetchingState == LoadingState.loading
              ? Center(
                  child: LoadingIndicator.small(context),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 64),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  CupertinoIcons.chevron_back,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: DummySearchTextField(
                                tag: 'search',
                                navigatingRouteName:
                                    MusicSearchScreen.routeScreen,
                                shouldPopCurrentRoute: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.search_normal,
                              size: 35,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Search Results',
                              style:
                                  Theme.of(context).textTheme.button?.copyWith(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                            ),
                          ],
                        ),
                      ),
                      ...snapshot.searchResultMusicItems
                          .map(
                            (e) => Column(
                              children: [
                                MusicListTile(
                                  selectedMusic: e,
                                  clearEarlierPlaylist: true,
                                ),
                                const Divider(),
                              ],
                            ),
                          )
                          .toList(),
                      const Divider(),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final LoadingState searchResultFetchingState;
  final List<MusicItem> searchResultMusicItems;
  final void Function(MusicItem) playMusic;
  _ViewModel({
    required this.searchResultFetchingState,
    required this.searchResultMusicItems,
    required this.playMusic,
  }) : super(equals: [
          searchResultFetchingState,
          searchResultMusicItems,
        ]);
}

class _Factory extends VmFactory<AppState, MusicSearchResultScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      searchResultFetchingState: state.searchState.searchResultFetchingState,
      searchResultMusicItems: state.searchState.searchResultMusicItems,
      playMusic: (mediaItem) async {
        await dispatch(
          PlayAudioAction(
            musicItem: mediaItem,
            clearEarlierPlaylist: true,
          ),
        );
      },
    );
  }
}
