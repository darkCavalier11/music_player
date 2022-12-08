// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/user_playlist_list_item.dart';

class UserPlaylistState {
  final List<UserPlaylistListItem> userPlaylistItems;
  final bool onEditState;
  UserPlaylistState({
    required this.userPlaylistItems,
    required this.onEditState,
  });

  UserPlaylistState copyWith({
    List<UserPlaylistListItem>? userPlaylistItems,
    bool? onEditState,
  }) {
    return UserPlaylistState(
      userPlaylistItems: userPlaylistItems ?? this.userPlaylistItems,
      onEditState: onEditState ?? this.onEditState,
    );
  }

  factory UserPlaylistState.initial() {
    return UserPlaylistState(
      userPlaylistItems: [],
      onEditState: false,
    );
  }

  @override
  String toString() =>
      'UserPlaylistState(userPlaylistItems: $userPlaylistItems, onEditState: $onEditState)';

  @override
  bool operator ==(covariant UserPlaylistState other) {
    if (identical(this, other)) return true;

    return listEquals(other.userPlaylistItems, userPlaylistItems) &&
        other.onEditState == onEditState;
  }

  @override
  int get hashCode => userPlaylistItems.hashCode ^ onEditState.hashCode;
}
