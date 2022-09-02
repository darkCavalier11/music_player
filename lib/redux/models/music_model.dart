import 'dart:developer';

import 'package:collection/collection.dart';

class MusicSearchStringResults {
  final String searchString;
  final List<String> searchResults;
  MusicSearchStringResults({
    required this.searchString,
    required this.searchResults,
  });

  @override
  String toString() =>
      'MusicSearchStringResults(searchString: $searchString, searchResults: $searchResults)';

  @override
  bool operator ==(covariant MusicSearchStringResults other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.searchString == searchString &&
        listEquals(other.searchResults, searchResults);
  }

  factory MusicSearchStringResults.initial() {
    return MusicSearchStringResults(
      searchString: '',
      searchResults: [],
    );
  }

  // this parsing different from regular json, only for specific use cases
  factory MusicSearchStringResults.fromCustomJson(List<dynamic> json) {
    try {
      final searchString = json[0] as String;
      final searchResults = <String>[];
      for (var result in json[1]) {
        searchResults.add(result[0] as String);
      }
      return MusicSearchStringResults(
        searchString: searchString,
        searchResults: searchResults,
      );
    } catch (err) {
      throw UnsupportedError(
          'Unable to parse MusicSearchResult -> $json -> $err');
    }
  }

  @override
  int get hashCode => searchString.hashCode ^ searchResults.hashCode;

  MusicSearchStringResults copyWith({
    String? searchString,
    List<String>? searchResults,
  }) {
    return MusicSearchStringResults(
      searchString: searchString ?? this.searchString,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
