// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/download_state.dart';
import 'package:music_player/redux/models/music_item.dart';

class AddMusicItemToDownload extends ReduxAction<AppState> {
  final MusicItem musicItem;
  AddMusicItemToDownload({
    required this.musicItem,
  });

  @override
  AppState reduce() {
    return state.copyWith(
      downloadState: state.downloadState.copyWith(
        musicItemDownloadList: state.downloadState.musicItemDownloadList
          ..add(
            MusicItemForDownload(
              musicItem: musicItem,
              progress: 0.0,
              cancelToken: CancelToken(),
              downloadStatus: DownloadStatus.progress,
            ),
          ),
      ),
    );
  }
}

class UpdateMusicItemDownloadProgress extends ReduxAction<AppState> {
  final String musicId;
  final double progress;
  UpdateMusicItemDownloadProgress({
    required this.musicId,
    required this.progress,
  });

  @override
  AppState? reduce() {
    final idx = state.downloadState.musicItemDownloadList
        .indexWhere((element) => element.musicItem.musicId == musicId);

    if (idx != -1) {
      final musicItemForDownload =
          state.downloadState.musicItemDownloadList[idx];
      if (progress == 1) {
        Fluttertoast.showToast(msg: 'Download complete.');
      }
      return state.copyWith(
        downloadState: state.downloadState.copyWith(
          musicItemDownloadList: state.downloadState.musicItemDownloadList
            ..[idx] = musicItemForDownload.copyWith(
              progress: progress,
              downloadStatus: progress == 1
                  ? DownloadStatus.completed
                  : DownloadStatus.progress,
            ),
        ),
      );
    }
  }
}

class CancelDownloadForMusicItem extends ReduxAction<AppState> {
  final String musicId;
  CancelDownloadForMusicItem({
    required this.musicId,
  });

  @override
  AppState? reduce() {
    final idx = state.downloadState.musicItemDownloadList.indexWhere(
      (element) => element.musicItem.musicId == musicId,
    );
    if (idx == -1) {
      return null;
    }
    final cancelToken =
        state.downloadState.musicItemDownloadList[idx].cancelToken;
    cancelToken.cancel();
    return state.copyWith(
      downloadState: state.downloadState.copyWith(
        musicItemDownloadList: state.downloadState.musicItemDownloadList
          ..removeAt(idx),
      ),
    );
  }
}
