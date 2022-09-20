import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaylistItemTile extends StatelessWidget {
  const PlaylistItemTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).disabledColor,
                        BlendMode.modulate,
                      ),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1513010963904-2fefe6a92780?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).hintColor,
                        BlendMode.modulate,
                      ),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1663431261867-01399cf8847d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1663475928373-12f26f48e4b4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          )),
                    ),
                    const Icon(
                      CupertinoIcons.play_arrow_solid,
                      size: 12,
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Playlist',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
                Text(
                  '26 Songs',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
                Text(
                  'Humane sagar, Kuldeep pattnaik, Mantu churia',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
