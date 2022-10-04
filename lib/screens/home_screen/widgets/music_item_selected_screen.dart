// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';
import 'package:music_player/screens/home_screen/widgets/music_list_tile.dart';
import 'package:music_player/widgets/app_primary_button.dart';

import '../../../redux/models/music_item.dart';

class MusicItemSelectedScreen extends StatelessWidget {
  static const routeName = '/musicItemSelectedScreen';
  final MusicItem musicItem;
  const MusicItemSelectedScreen({
    Key? key,
    required this.musicItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor.withOpacity(0.9),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.all(0),
                  splashColor: Colors.redAccent.withOpacity(0.2),
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.heart,
                    color: Colors.redAccent,
                  ),
                ),
                AppPrimaryButton(
                  buttonText: 'Add To Playlist',
                  trailingIcon: Icon(
                    Iconsax.music_playlist,
                    size: 18,
                  ),
                ),
                AppPrimaryButton(
                  buttonText: 'Show next',
                  trailingIcon: Icon(
                    CupertinoIcons.list_bullet,
                    size: 18,
                  ),
                ),
              ],
            ),
            Hero(
              tag: musicItem.musicId,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MusicListTile(
                  selectedMusic: musicItem,
                  onTap: (p) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
