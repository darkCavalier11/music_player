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
  int _navBarIndex = 0;
  static double getIconPosition(double navBarWidth, int index) {
    switch (index) {
      case 0:
        return 10;
      case 1:
        return navBarWidth / 3 - 10;
      case 2:
        return 2 * navBarWidth / 3 - 30;
      default:
        return navBarWidth - 50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn,
            left: getIconPosition(
                MediaQuery.of(context).size.width * 0.8, _navBarIndex),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Theme.of(context).primaryColor.withOpacity(0.1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _navBarIndex = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Icon(
                      _navBarIndex == 0 ? Iconsax.home1 : Iconsax.home_2,
                      color: _navBarIndex == 0 ? Colors.white : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _navBarIndex = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      _navBarIndex == 1
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: _navBarIndex == 1 ? Colors.white : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _navBarIndex = 2;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      _navBarIndex == 2
                          ? Iconsax.music_playlist5
                          : Iconsax.music_playlist,
                      color: _navBarIndex == 2 ? Colors.white : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _navBarIndex = 3;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      _navBarIndex == 3
                          ? CupertinoIcons.person_fill
                          : CupertinoIcons.person,
                      color: _navBarIndex == 3 ? Colors.white : null,
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
