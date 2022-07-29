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
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
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
                    setState(() {
                      _navBarIndex = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Iconsax.home_1,
                      color: _navBarIndex == 0
                          ? Colors.white
                          : Theme.of(context).primaryColor,
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
                      CupertinoIcons.heart,
                      color: _navBarIndex == 1
                          ? Colors.white
                          : Theme.of(context).primaryColor,
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
                      Iconsax.music_playlist,
                      color: _navBarIndex == 2
                          ? Colors.white
                          : Theme.of(context).primaryColor,
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
                      CupertinoIcons.person,
                      color: _navBarIndex == 3
                          ? Colors.white
                          : Theme.of(context).primaryColor,
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
