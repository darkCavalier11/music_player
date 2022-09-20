// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaylistItemTile extends StatelessWidget {
  final String imageUrl1;
  final String? imageUrl2;
  final String? imageUrl3;

  const PlaylistItemTile({
    Key? key,
    required this.imageUrl1,
    this.imageUrl2,
    this.imageUrl3,
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
                if (imageUrl3 != null)
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
                          imageUrl3!,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                if (imageUrl2 != null)
                  Positioned(
                    left: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).hintColor,
                          BlendMode.modulate,
                        ),
                        child: Image(
                          image: CachedNetworkImageProvider(imageUrl2 ?? ''),
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
                      child: Image(
                        image: CachedNetworkImageProvider(imageUrl1),
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
                        ),
                      ),
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
