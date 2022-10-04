// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/music_item.dart';

class UserPlaylistListItem {
  final String id;
  final String title;
  final List<MusicItem> musicItems;
  UserPlaylistListItem({
    required this.id,
    required this.title,
    required this.musicItems,
  });

  String getPlaylistAuthorSubtitle() {
    final authors = <String>[];
    for (var musicItem in musicItems) {
      authors.add(musicItem.author);
    }
    return authors.join(',');
  }

  factory UserPlaylistListItem.fromJson(Map<String, dynamic> json) {
    return UserPlaylistListItem(
      id: json['id'],
      title: json['title'],
      musicItems: (json['musicItems'] as List)
          .map(
            (e) => MusicItem.fromJson(e),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'musicItems': musicItems
          .map(
            (e) => e.toJson(),
          )
          .toList(),
    };
  }

  @override
  String toString() =>
      'UserPlaylistListItem(id: $id, title: $title, musicItems: $musicItems)';

  UserPlaylistListItem copyWith({
    String? id,
    String? title,
    List<MusicItem>? musicItems,
  }) {
    return UserPlaylistListItem(
      id: id ?? this.id,
      title: title ?? this.title,
      musicItems: musicItems ?? this.musicItems,
    );
  }

  @override
  bool operator ==(covariant UserPlaylistListItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        listEquals(other.musicItems, musicItems);
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ musicItems.hashCode;
}
