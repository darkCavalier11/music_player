import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/music_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SearchState {
  final String query;
  // todo : fetch from db
  final List<String> previouslySearchedItems;
  final MusicSearchStringResults musicSearchResults;
  final LoadingState currentSeacrhState;
  final LoadingState searchResultFetchingState;
  final List<MusicItem> searchResultMusicItems;
  SearchState({
    required this.query,
    required this.previouslySearchedItems,
    required this.musicSearchResults,
    required this.currentSeacrhState,
    required this.searchResultFetchingState,
    required this.searchResultMusicItems,
  });

  SearchState copyWith({
    String? query,
    List<String>? previouslySearchedItems,
    MusicSearchStringResults? musicSearchResults,
    LoadingState? currentSeacrhState,
    LoadingState? searchResultFetchingState,
    List<MusicItem>? searchResultMusicItems,
  }) {
    return SearchState(
      query: query ?? this.query,
      previouslySearchedItems:
          previouslySearchedItems ?? this.previouslySearchedItems,
      musicSearchResults: musicSearchResults ?? this.musicSearchResults,
      currentSeacrhState: currentSeacrhState ?? this.currentSeacrhState,
      searchResultFetchingState:
          searchResultFetchingState ?? this.searchResultFetchingState,
      searchResultMusicItems:
          searchResultMusicItems ?? this.searchResultMusicItems,
    );
  }

  factory SearchState.initial() {
    return SearchState(
      query: '',
      previouslySearchedItems: [],
      musicSearchResults: MusicSearchStringResults.initial(),
      currentSeacrhState: LoadingState.idle,
      searchResultMusicItems: [],
      searchResultFetchingState: LoadingState.idle,
    );
  }

  @override
  String toString() {
    return 'SearchState(query: $query, previouslySearchedItems: $previouslySearchedItems, musicSearchResults: $musicSearchResults, currentSeacrhState: $currentSeacrhState, searchResultFetchingState: $searchResultFetchingState, searchResultMusicItems: $searchResultMusicItems)';
  }

  @override
  bool operator ==(covariant SearchState other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        listEquals(other.previouslySearchedItems, previouslySearchedItems) &&
        other.musicSearchResults == musicSearchResults &&
        other.currentSeacrhState == currentSeacrhState &&
        other.searchResultFetchingState == searchResultFetchingState &&
        listEquals(other.searchResultMusicItems, searchResultMusicItems);
  }

  @override
  int get hashCode {
    return query.hashCode ^
        previouslySearchedItems.hashCode ^
        musicSearchResults.hashCode ^
        currentSeacrhState.hashCode ^
        searchResultFetchingState.hashCode ^
        searchResultMusicItems.hashCode;
  }
}

enum LoadingState {
  idle,
  loading,
  failed,
}
