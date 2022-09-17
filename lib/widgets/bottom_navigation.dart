// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Theme.of(context).disabledColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BottomNavigationButton(
              enabledText: 'Home',
              icon: CupertinoIcons.home,
              enabled: false,
            ),
            _BottomNavigationButton(
              enabledText: 'Playlist',
              icon: Iconsax.music_playlist,
              enabled: false,
            ),
            _BottomNavigationButton(
              enabledText: 'Account',
              icon: CupertinoIcons.person,
              enabled: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigationButton extends StatelessWidget {
  final IconData icon;
  final String enabledText;
  final bool enabled;
  const _BottomNavigationButton({
    Key? key,
    required this.icon,
    required this.enabledText,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return enabled
        ? Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  enabledText,
                  style: Theme.of(context).textTheme.button?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                )
              ],
            ),
          )
        : Icon(icon);
  }
}
