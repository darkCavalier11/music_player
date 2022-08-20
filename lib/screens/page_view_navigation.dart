// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';

import 'package:music_player/screens/home_screen/widgets/bottom_navigation_cluster.dart';
import 'package:music_player/screens/playlist_screen/playlist_screen.dart';

import 'account_screen/account_screen.dart';
import 'favorite_page/favorite_screen.dart';
import 'home_screen/home_screen.dart';

class PageViewNavigation extends StatefulWidget {
  const PageViewNavigation({
    Key? key,
  }) : super(key: key);

  @override
  State<PageViewNavigation> createState() => _PageViewNavigationState();
}

class _PageViewNavigationState extends State<PageViewNavigation> {
  late PageController _pageController;

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
      builder: (context, snapshot) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            PageView(
              controller: _pageController,
              pageSnapping: true,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                snapshot.changeBottomNavIndex(page);
              },
              children: const [
                HomeScreen(),
                FavoriteScreen(),
                PlaylistScreen(),
                AccountScreen(),
              ],
            ),
            BottomNavigationCluster(onPageChanged: (page) {
              _pageController.animateToPage(
                page,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 200),
              );
            }),
          ],
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final Function(int) changeBottomNavIndex;
  final int currentBottomNavIndex;
  _ViewModel({
    required this.changeBottomNavIndex,
    required this.currentBottomNavIndex,
  });
}

class _Factory extends VmFactory<AppState, _PageViewNavigationState> {
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
