import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigationView extends StatelessWidget {
  const BottomNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {},
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'fav',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.music_playlist),
            label: 'playlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'account',
          ),
        ],
      ),
      body: Center(
        child: Text('Hello'),
      ),
    );
  }
}
