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
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.home,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Home',
                    style: Theme.of(context).textTheme.button?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  )
                ],
              ),
            ),
            Icon(
              Iconsax.music_playlist,
              size: 20,
            ),
            Icon(
              CupertinoIcons.person,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
