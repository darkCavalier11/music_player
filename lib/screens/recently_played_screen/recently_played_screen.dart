import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_player/widgets/app_text_field.dart';
import 'package:music_player/widgets/search_text_field.dart';

class RecentlyPlayedScreen extends StatelessWidget {
  const RecentlyPlayedScreen({Key? key}) : super(key: key);

  static const recentlyPlayedScreen = "recentlyPlayedScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AppTextField(
              hintText: 'Search Recently played Items...',
              leadingIcon: Icons.search,
            ),
            const SizedBox(height: 10),
            Hero(
              tag: 'RECENTLY_PLAYED',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.stopwatch,
                      size: 35,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Recently played',
                      style: Theme.of(context).textTheme.button?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
