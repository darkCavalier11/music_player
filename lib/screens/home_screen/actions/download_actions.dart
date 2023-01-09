// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';

import 'package:music_player/redux/models/app_state.dart';

class AddMusicItemToDownload extends ReduxAction<AppState> {
  final String musicId;
  AddMusicItemToDownload({
    required this.musicId,
  });

  @override
  AppState reduce() {
    return state.copyWith(
      downloadState: state.downloadState.copyWith(
        musicIdToDownloadProgressMap:
            state.downloadState.musicIdToDownloadProgressMap..[musicId] = 0.0,
        musciIdToCancelTokenMap: state.downloadState.musciIdToCancelTokenMap
          ..[musicId] = CancelToken(),
      ),
    );
  }
}

class UpdateMusicItemProgress extends ReduxAction<AppState> {
  final String musicId;
  final double progress;
  UpdateMusicItemProgress({
    required this.musicId,
    required this.progress,
  });

  @override
  AppState reduce() {
    return state.copyWith(
      downloadState: state.downloadState.copyWith(
        musicIdToDownloadProgressMap:
            state.downloadState.musicIdToDownloadProgressMap
              ..[musicId] = progress,
      ),
    );
  }
}

class CancelDownloadForMusicItem extends ReduxAction<AppState> {
  final String musicId;
  CancelDownloadForMusicItem({
    required this.musicId,
  });

  @override
  AppState? reduce() {
    final cancelToken = state.downloadState.musciIdToCancelTokenMap[musicId];
    cancelToken?.cancel();
    return state.copyWith(
      downloadState: state.downloadState.copyWith(
        musicIdToDownloadProgressMap:
            state.downloadState.musicIdToDownloadProgressMap
              ..removeWhere((key, value) => key == musicId),
      ),
    );
  }
}
