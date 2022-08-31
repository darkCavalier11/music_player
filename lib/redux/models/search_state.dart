import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/music_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SearchState {
  final String query;
  final List<String> previouslySearchedItems;
  final MusicSearchResults musicSearchResults;
  final LoadingState currentSeacrhState;
  final List<MusicItem> searchResultMusicItems;
  SearchState({
    required this.query,
    required this.previouslySearchedItems,
    required this.musicSearchResults,
    required this.currentSeacrhState,
    required this.searchResultMusicItems,
  });

  SearchState copyWith({
    String? query,
    List<String>? previouslySearchedItems,
    MusicSearchResults? musicSearchResults,
    LoadingState? currentSeacrhState,
    List<MusicItem>? searchResultMusicItems,
  }) {
    return SearchState(
      query: query ?? this.query,
      previouslySearchedItems: previouslySearchedItems ?? this.previouslySearchedItems,
      musicSearchResults: musicSearchResults ?? this.musicSearchResults,
      currentSeacrhState: currentSeacrhState ?? this.currentSeacrhState,
      searchResultMusicItems: searchResultMusicItems ?? this.searchResultMusicItems,
    );
  }

  factory SearchState.initial() {
    return SearchState(
      query: '',
      previouslySearchedItems: [],
      musicSearchResults: MusicSearchResults.initial(),
      currentSeacrhState: LoadingState.idle,
      searchResultMusicItems: [],
    );
  }

  @override
  String toString() {
    return 'SearchState(query: $query, previouslySearchedItems: $previouslySearchedItems, musicSearchResults: $musicSearchResults, currentSeacrhState: $currentSeacrhState, searchResultMusicItems: $searchResultMusicItems)';
  }

  @override
  bool operator ==(covariant SearchState other) {
    if (identical(this, other)) return true;
  
    return 
      other.query == query &&
      listEquals(other.previouslySearchedItems, previouslySearchedItems) &&
      other.musicSearchResults == musicSearchResults &&
      other.currentSeacrhState == currentSeacrhState &&
      listEquals(other.searchResultMusicItems, searchResultMusicItems);
  }

  @override
  int get hashCode {
    return query.hashCode ^
      previouslySearchedItems.hashCode ^
      musicSearchResults.hashCode ^
      currentSeacrhState.hashCode ^
      searchResultMusicItems.hashCode;
  }
}

enum LoadingState {
  idle,
  loading,
  failed,
}