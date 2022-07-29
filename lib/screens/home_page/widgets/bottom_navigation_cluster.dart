import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigationCluster extends StatefulWidget {
  const BottomNavigationCluster({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavigationCluster> createState() =>
      _BottomNavigationClusterState();
}

class _BottomNavigationClusterState extends State<BottomNavigationCluster> {
  Widget _homeIcon = const Icon(Iconsax.home1);
  Widget _favIcon = const Icon(CupertinoIcons.heart);
  Widget _playlistIcon = const Icon(Iconsax.music_playlist);
  Widget _accountIcon = const Icon(CupertinoIcons.person);

  void _selectNavByIndex(int index) {
    _navBarIndex = index;
    _homeIcon = const Icon(
      Iconsax.home_1,
      key: ValueKey<int>(0),
    );
    _favIcon = const Icon(
      CupertinoIcons.heart,
      key: ValueKey<int>(1),
    );
    _playlistIcon = const Icon(
      Iconsax.music_playlist,
      key: ValueKey<int>(2),
    );
    _accountIcon = const Icon(
      CupertinoIcons.person,
      key: ValueKey<int>(3),
    );
    switch (index) {
      case 0:
        _homeIcon = const Icon(
          Iconsax.home1,
          color: Colors.white,
          key: ValueKey<int>(10),
        );
        break;
      case 1:
        _favIcon = const Icon(
          CupertinoIcons.heart_fill,
          color: Colors.white,
          key: ValueKey<int>(11),
        );
        break;
      case 2:
        _playlistIcon = const Icon(
          Iconsax.music_playlist5,
          color: Colors.white,
          key: ValueKey<int>(12),
        );
        break;
      case 3:
        _accountIcon = const Icon(
          CupertinoIcons.person_fill,
          color: Colors.white,
          key: ValueKey<int>(14),
        );
        break;
    }
    setState(() {});
  }

  int _navBarIndex = 0;
  static double getIconPosition(double navBarWidth, int index) {
    switch (index) {
      case 0:
        return 21;
      case 1:
        return navBarWidth / 3 - 9;
      case 2:
        return 2 * navBarWidth / 3 - 40;
      default:
        return navBarWidth - 71;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectNavByIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -10,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            left: getIconPosition(
                MediaQuery.of(context).size.width, _navBarIndex),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
            duration: const Duration(milliseconds: 200),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _selectNavByIndex(0);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: AnimatedSwitcher(
                      reverseDuration: const Duration(seconds: 0),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      duration: const Duration(milliseconds: 200),
                      child: _homeIcon,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _selectNavByIndex(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: AnimatedSwitcher(
                      reverseDuration: const Duration(seconds: 0),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: _favIcon,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _selectNavByIndex(2);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: AnimatedSwitcher(
                      reverseDuration: const Duration(seconds: 0),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: _playlistIcon,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _selectNavByIndex(3);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: AnimatedSwitcher(
                      reverseDuration: const Duration(seconds: 0),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: _accountIcon,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
