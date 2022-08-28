import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';

import '../home_screen/home_screen.dart';
import '../music_search_screen/music_search_screen.dart';

class MusicSearchResultScreen extends StatelessWidget {
  static const routeName = '/musicSearchResultScreen';
  const MusicSearchResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 64),
            child: DummySearchTextField(
              tag: 'search',
              navigatingRouteName: MusicSearchScreen.routeScreen,
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
                  style: Theme.of(context).textTheme.button?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
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
