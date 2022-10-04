// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';
import 'package:music_player/screens/home_screen/widgets/music_list_tile.dart';
import 'package:music_player/widgets/app_primary_button.dart';

import '../../../redux/models/music_item.dart';

class MusicItemSelectedScreen extends StatefulWidget {
  static const routeName = '/musicItemSelectedScreen';
  final MusicItem musicItem;
  const MusicItemSelectedScreen({
    Key? key,
    required this.musicItem,
  }) : super(key: key);

  @override
  State<MusicItemSelectedScreen> createState() =>
      _MusicItemSelectedScreenState();
}

class _MusicItemSelectedScreenState extends State<MusicItemSelectedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _animationController.reverse();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 25,
                sigmaY: 25,
              ),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor.withOpacity(0.1),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: widget.musicItem.musicId,
                    child: MusicListTile(
                      selectedMusic: widget.musicItem,
                      onTap: (p) {},
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animationController.value,
                        child: Transform.translate(
                          offset:
                              Offset(0, (1 - _animationController.value) * 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                splashColor: Colors.redAccent.withOpacity(0.2),
                                onPressed: () {},
                                icon: const Icon(
                                  CupertinoIcons.heart,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const AppPrimaryButton(
                                buttonText: 'Add To Playlist',
                                trailingIcon: Icon(
                                  Iconsax.music_playlist,
                                  size: 18,
                                ),
                              ),
                              const AppPrimaryButton(
                                buttonText: 'Show next',
                                trailingIcon: Icon(
                                  CupertinoIcons.list_bullet,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
