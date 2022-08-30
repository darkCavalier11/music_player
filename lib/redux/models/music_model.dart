import 'dart:developer';

import 'package:collection/collection.dart';

class MusicSearchResults {
  final String searchString;
  final List<String> searchResults;
  MusicSearchResults({
    required this.searchString,
    required this.searchResults,
  });

  @override
  String toString() =>
      'MusicSearchResults(searchString: $searchString, searchResults: $searchResults)';

  @override
  bool operator ==(covariant MusicSearchResults other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.searchString == searchString &&
        listEquals(other.searchResults, searchResults);
  }

  factory MusicSearchResults.initial() {
    return MusicSearchResults(
      searchString: '',
      searchResults: [],
    );
  }

  // this parsing different from regular json, only for specific use cases
  factory MusicSearchResults.fromCustomJson(List<dynamic> json) {
    log(json.toString());
    try {
      final searchString = json[0] as String;
      final searchResults = <String>[];
      for (var result in json[1]) {
        searchResults.add(result[0] as String);
      }
      return MusicSearchResults(
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

  MusicSearchResults copyWith({
    String? searchString,
    List<String>? searchResults,
  }) {
    return MusicSearchResults(
      searchString: searchString ?? this.searchString,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
