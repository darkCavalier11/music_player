// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DownloadState {
  final Map<String, double> musicIdToDownloadProgressMap;
  final Map<String, CancelToken> musciIdToCancelTokenMap;
  DownloadState({
    required this.musicIdToDownloadProgressMap,
    required this.musciIdToCancelTokenMap,
  });

  DownloadState copyWith({
    Map<String, double>? musicIdToDownloadProgressMap,
    Map<String, CancelToken>? musciIdToCancelTokenMap,
  }) {
    return DownloadState(
      musicIdToDownloadProgressMap:
          musicIdToDownloadProgressMap ?? this.musicIdToDownloadProgressMap,
      musciIdToCancelTokenMap:
          musciIdToCancelTokenMap ?? this.musciIdToCancelTokenMap,
    );
  }

  factory DownloadState.initial() {
    return DownloadState(
      musicIdToDownloadProgressMap: {},
      musciIdToCancelTokenMap: {},
    );
  }

  @override
  String toString() =>
      'DownloadState(musicIdToDownloadProgressMap: $musicIdToDownloadProgressMap, musciIdToCancelTokenMap: $musciIdToCancelTokenMap)';

  @override
  bool operator ==(covariant DownloadState other) {
    if (identical(this, other)) return true;

    return mapEquals(
            other.musicIdToDownloadProgressMap, musicIdToDownloadProgressMap) &&
        mapEquals(other.musciIdToCancelTokenMap, musciIdToCancelTokenMap);
  }

  @override
  int get hashCode =>
      musicIdToDownloadProgressMap.hashCode ^ musciIdToCancelTokenMap.hashCode;
}
