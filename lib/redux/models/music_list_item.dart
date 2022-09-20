// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/music_item.dart';

class MusicListItem {
  final String title;
  final List<MusicItem> musicItems;
  MusicListItem({
    required this.title,
    required this.musicItems,
  });

  factory MusicListItem.fromJson(Map<String, dynamic> json) {
    return MusicListItem(
      title: json['title'],
      musicItems: (json['musicItem'] as List)
          .map(
            (e) => MusicItem.fromJson(e),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'musicItems': musicItems.map(
        (e) => e.toJson(),
      )
    };
  }

  @override
  String toString() => 'MusicListItem(title: $title, musicItems: $musicItems)';

  MusicListItem copyWith({
    String? title,
    List<MusicItem>? musicItems,
  }) {
    return MusicListItem(
      title: title ?? this.title,
      musicItems: musicItems ?? this.musicItems,
    );
  }

  @override
  bool operator ==(covariant MusicListItem other) {
    if (identical(this, other)) return true;

    return other.title == title && listEquals(other.musicItems, musicItems);
  }

  @override
  int get hashCode => title.hashCode ^ musicItems.hashCode;
}
