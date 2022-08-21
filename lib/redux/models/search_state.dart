import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SearchState {
  final String query;
  final List<String> previouslySearchedItems;
  SearchState({
    required this.query,
    required this.previouslySearchedItems,
  });

  SearchState copyWith({
    String? query,
    List<String>? previouslySearchedItems,
  }) {
    return SearchState(
      query: query ?? this.query,
      previouslySearchedItems:
          previouslySearchedItems ?? this.previouslySearchedItems,
    );
  }

  factory SearchState.initial() {
    return SearchState(
      query: '',
      previouslySearchedItems: [],
    );
  }

  @override
  String toString() =>
      'SearchState(query: $query, previouslySearchedItems: $previouslySearchedItems)';

  @override
  bool operator ==(covariant SearchState other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        listEquals(other.previouslySearchedItems, previouslySearchedItems);
  }

  @override
  int get hashCode => query.hashCode ^ previouslySearchedItems.hashCode;
}
