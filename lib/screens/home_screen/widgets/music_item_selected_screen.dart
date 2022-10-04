// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_player/screens/home_screen/widgets/music_list_tile.dart';

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
            Hero(
              tag: musicItem.musicId,
              child: MusicListTile(
                selectedMusic: musicItem,
                onTap: (p) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
