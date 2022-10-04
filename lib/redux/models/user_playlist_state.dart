// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/user_playlist_list_item.dart';

class UserPlaylistState {
  final List<UserPlaylistListItem> userPlaylistItems;
  UserPlaylistState({
    required this.userPlaylistItems,
  });

  UserPlaylistState copyWith({
    List<UserPlaylistListItem>? userPlaylistItems,
  }) {
    return UserPlaylistState(
      userPlaylistItems: userPlaylistItems ?? this.userPlaylistItems,
    );
  }

  factory UserPlaylistState.initial() {
    return UserPlaylistState(userPlaylistItems: []);
  }

  @override
  String toString() => 'UserPlaylistState(userPlaylistItems: $userPlaylistItems)';

  @override
  bool operator ==(covariant UserPlaylistState other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.userPlaylistItems, userPlaylistItems);
  }

  @override
  int get hashCode => userPlaylistItems.hashCode;
}
