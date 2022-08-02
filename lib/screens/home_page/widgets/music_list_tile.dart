import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicListTile extends StatelessWidget {
  const MusicListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              CupertinoIcons.music_mic,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dil to baccha hai ji',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Rahat Fateh Ali Khan',
                  style: Theme.of(context).textTheme.overline?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.play_arrow,
                  size: 18,
                ),
                Text(
                  '3:37',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
