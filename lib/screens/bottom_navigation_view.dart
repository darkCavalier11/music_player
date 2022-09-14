// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/screens/account_screen/account_screen.dart';
import 'package:music_player/screens/favorite_page/favorite_screen.dart';
import 'package:music_player/screens/home_screen/home_screen.dart';
import 'package:music_player/screens/playlist_screen/playlist_screen.dart';

final _screenIndex = <Widget>[
  HomeScreen(),
  FavoriteScreen(),
  PlaylistScreen(),
  AccountScreen(),
];

class BottomNavigationView extends StatelessWidget {
  const BottomNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: snapshot.changeBottomNavIndex,
          currentIndex: snapshot.currentBottomNavIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart),
              label: 'Fav',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.music_playlist),
              label: 'Playlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Account',
            ),
          ],
        ),
        body: _screenIndex[snapshot.currentBottomNavIndex],
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, BottomNavigationView> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
        currentBottomNavIndex: state.uiState.currentBottomNavIndex,
        changeBottomNavIndex: (index) {
          dispatch(ChangeBottomNavIndex(index: index));
        });
  }
}

class _ViewModel extends Vm {
  final int currentBottomNavIndex;
  final Function(int) changeBottomNavIndex;
  _ViewModel({
    required this.currentBottomNavIndex,
    required this.changeBottomNavIndex,
  });

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.currentBottomNavIndex == currentBottomNavIndex &&
        other.changeBottomNavIndex == changeBottomNavIndex;
  }

  @override
  int get hashCode =>
      currentBottomNavIndex.hashCode ^ changeBottomNavIndex.hashCode;
}
