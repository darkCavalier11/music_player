import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';
import 'package:music_player/screens/home_screen/home_screen.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Iconsax.home,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Tab(
                text: 'World',
              )
            ],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Theme.of(context).primaryColor,
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen(),
            Container(
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }
}
