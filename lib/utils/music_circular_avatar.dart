import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MusicCircularAvatar extends StatelessWidget {
  final String? imageUrl;
  const MusicCircularAvatar({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 25,
      backgroundImage: imageUrl != null
          ? CachedNetworkImageProvider(
              imageUrl!,
            )
          : null,
      child: imageUrl == null || imageUrl!.isEmpty
          ? const Icon(Icons.music_note_outlined)
          : null,
    );
  }
}
