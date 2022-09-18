// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/screens/account_screen/account_screen.dart';
import 'package:music_player/widgets/bottom_navigation.dart';
import 'package:music_player/screens/favorite_page/favorite_screen.dart';
import 'package:music_player/screens/home_screen/home_screen.dart';
import 'package:music_player/screens/playlist_screen/playlist_screen.dart';

const _screens = <Widget>[
  HomeScreen(),
  PlaylistScreen(),
  AccountScreen(),
];

class AppScreens extends StatefulWidget {
  const AppScreens({Key? key}) : super(key: key);

  @override
  State<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends State<AppScreens> {
  late PageController _pageController;
  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      onInit: (store) {
        store.onChange.listen((newState) async {
          await Future.delayed(const Duration(milliseconds: 100));
          if (newState.uiState.currentBottomNavIndex != _currentIndex) {
            _currentIndex = newState.uiState.currentBottomNavIndex;
            _pageController.animateToPage(
              _currentIndex,
              duration: const Duration(milliseconds: 100),
              curve: Curves.fastOutSlowIn,
            );
          }
        });
      },
      builder: (context, snapshot) {
        return Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView(
                  controller: _pageController,
                  children: _screens,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (page) async {
                    await Future.delayed(const Duration(milliseconds: 100));
                    snapshot.changeBottomNavIndex(page);
                  },
                ),
                Positioned(
                  bottom: 15,
                  child: BottomNavigationWidget(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Factory extends VmFactory<AppState, _AppScreensState> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      currentBottomNavIndex: state.uiState.currentBottomNavIndex,
      changeBottomNavIndex: (index) {
        dispatch(ChangeBottomNavIndex(index: index));
      },
    );
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
