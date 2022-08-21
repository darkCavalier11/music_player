import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SearchState {
  final String query;
  final List<String> previouslySearchedItems;
  final List<String> searchResults;
  SearchState({
    required this.query,
    required this.previouslySearchedItems,
    required this.searchResults,
  });

  SearchState copyWith({
    String? query,
    List<String>? previouslySearchedItems,
    List<String>? searchResults,
  }) {
    return SearchState(
      query: query ?? this.query,
      previouslySearchedItems: previouslySearchedItems ?? this.previouslySearchedItems,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  factory SearchState.initial() {
    return SearchState(
      query: '',
      previouslySearchedItems: [],
      searchResults: [],
    );
  }

  @override
  String toString() => 'SearchState(query: $query, previouslySearchedItems: $previouslySearchedItems, searchResults: $searchResults)';

  @override
  bool operator ==(covariant SearchState other) {
    if (identical(this, other)) return true;
  
    return 
      other.query == query &&
      listEquals(other.previouslySearchedItems, previouslySearchedItems) &&
      listEquals(other.searchResults, searchResults);
  }

  @override
  int get hashCode => query.hashCode ^ previouslySearchedItems.hashCode ^ searchResults.hashCode;
}
