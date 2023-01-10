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
  final DownloadStatus downloadStatus;
  MusicItemForDownload({
    required this.musicId,
    required this.progress,
    required this.cancelToken,
    required this.downloadStatus,
  });

  MusicItemForDownload copyWith({
    String? musicId,
    double? progress,
    CancelToken? cancelToken,
    DownloadStatus? downloadStatus,
  }) {
    return MusicItemForDownload(
      musicId: musicId ?? this.musicId,
      progress: progress ?? this.progress,
      cancelToken: cancelToken ?? this.cancelToken,
      downloadStatus: downloadStatus ?? this.downloadStatus,
    );
  }

  @override
  String toString() {
    return 'MusicItemForDownload(musicId: $musicId, progress: $progress, cancelToken: $cancelToken, downloadStatus: $downloadStatus)';
  }

  @override
  bool operator ==(covariant MusicItemForDownload other) {
    if (identical(this, other)) return true;
  
    return 
      other.musicId == musicId &&
      other.progress == progress &&
      other.cancelToken == cancelToken &&
      other.downloadStatus == downloadStatus;
  }

  @override
  int get hashCode {
    return musicId.hashCode ^
      progress.hashCode ^
      cancelToken.hashCode ^
      downloadStatus.hashCode;
  }
}

enum DownloadStatus {
  loading,
  progress,
  completed,
  error,
}
