// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DownloadState {
  final List<MusicItemForDownload> musicItemDownloadList;
  DownloadState({
    required this.musicItemDownloadList,
  });

  factory DownloadState.initial() {
    return DownloadState(
      musicItemDownloadList: [],
    );
  }

  DownloadState copyWith({
    List<MusicItemForDownload>? musicItemDownloadList,
  }) {
    return DownloadState(
      musicItemDownloadList:
          musicItemDownloadList ?? this.musicItemDownloadList,
    );
  }

  @override
  String toString() =>
      'DownloadState(musicItemDownloadList: $musicItemDownloadList)';

  @override
  bool operator ==(covariant DownloadState other) {
    if (identical(this, other)) return true;

    return listEquals(other.musicItemDownloadList, musicItemDownloadList);
  }

  @override
  int get hashCode => musicItemDownloadList.hashCode;
}

class MusicItemForDownload {
  final String musicId;
  final double progress;
  final CancelToken cancelToken;
  MusicItemForDownload({
    required this.musicId,
    required this.progress,
    required this.cancelToken,
  });

  MusicItemForDownload copyWith({
    String? musicId,
    double? progress,
    CancelToken? cancelToken,
  }) {
    return MusicItemForDownload(
      musicId: musicId ?? this.musicId,
      progress: progress ?? this.progress,
      cancelToken: cancelToken ?? this.cancelToken,
    );
  }

  @override
  String toString() =>
      'MusicItemForDownload(musicId: $musicId, progress: $progress, cancelToken: $cancelToken)';

  @override
  bool operator ==(covariant MusicItemForDownload other) {
    if (identical(this, other)) return true;

    return other.musicId == musicId &&
        other.progress == progress &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      musicId.hashCode ^ progress.hashCode ^ cancelToken.hashCode;
}
