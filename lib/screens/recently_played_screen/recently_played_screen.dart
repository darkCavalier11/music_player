// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/screens/home_screen/widgets/music_list_tile.dart';
import 'package:music_player/widgets/app_text_field.dart';
import 'package:music_player/widgets/text_themes/app_header_text.dart';

import '../../widgets/app_back_button.dart';

class RecentlyPlayedScreen extends StatelessWidget {
  const RecentlyPlayedScreen({Key? key}) : super(key: key);

  static const recentlyPlayedScreen = "recentlyPlayedScreen";

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 24, right: 24, top: 64),
              ),
              const SizedBox(height: 16),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(8),
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        CupertinoIcons.back,
                        color: Theme.of(context).disabledColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const AppHeaderText(
                        icon: Iconsax.timer_1, text: 'Recently played'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return MusicListTile(
                      selectedMusic: snapshot.recentlyPlayedList[index],
                      clearEarlierPlaylist: true,
                    );
                  },
                  itemCount: snapshot.recentlyPlayedList.length,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final List<MusicItem> recentlyPlayedList;
  _ViewModel({
    required this.recentlyPlayedList,
  });
}

class _Factory extends VmFactory<AppState, RecentlyPlayedScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      recentlyPlayedList: state.homePageState.recentlyPlayedMusicList,
    );
  }
}
