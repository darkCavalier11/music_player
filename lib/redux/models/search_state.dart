import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/music_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SearchState {
  final String query;
  final List<String> previouslySearchedItems;
  final MusicSearchResults musicSearchResults;
  SearchState({
    required this.query,
    required this.previouslySearchedItems,
    required this.musicSearchResults,
  });

  SearchState copyWith({
    String? query,
    List<String>? previouslySearchedItems,
    MusicSearchResults? musicSearchResults,
  }) {
    return SearchState(
      query: query ?? this.query,
      previouslySearchedItems:
          previouslySearchedItems ?? this.previouslySearchedItems,
      musicSearchResults: musicSearchResults ?? this.musicSearchResults,
    );
  }

  factory SearchState.initial() {
    return SearchState(
      query: '',
      previouslySearchedItems: [],
      musicSearchResults: MusicSearchResults.initial(),
    );
  }

  @override
  String toString() =>
      'SearchState(query: $query, previouslySearchedItems: $previouslySearchedItems, musicSearchResults: $musicSearchResults)';

  @override
  bool operator ==(covariant SearchState other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        listEquals(other.previouslySearchedItems, previouslySearchedItems) &&
        other.musicSearchResults == musicSearchResults;
  }

  @override
  int get hashCode =>
      query.hashCode ^
      previouslySearchedItems.hashCode ^
      musicSearchResults.hashCode;
}
