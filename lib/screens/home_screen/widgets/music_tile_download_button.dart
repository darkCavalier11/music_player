import 'dart:developer';
import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../redux/models/app_state.dart';
import '../../../redux/models/download_state.dart';
import '../../../redux/models/music_item.dart';
import '../../../utils/api_request.dart';
import '../../../utils/yt_parser/lib/parser_helper.dart';
import '../actions/download_actions.dart';

class MusicTileDownloadButton extends StatelessWidget {
  const MusicTileDownloadButton({
    Key? key,
    required this.musicItem,
  }) : super(key: key);

  final MusicItem musicItem;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return IconButton(
          padding: const EdgeInsets.all(0),
          visualDensity: VisualDensity.compact,
          onPressed: () async {
            try {
              final per = await Permission.manageExternalStorage.request();
              if (per.isGranted) {
                final musicUrl =
                    await ParserHelper.getMusicItemUrl(musicItem.musicId);
                final savePath = await FilePicker.platform.getDirectoryPath();
                if (savePath != null) {
                  final file = File(savePath +
                      '/${musicItem.title.replaceAll('|', '_').replaceAll(',', '')}.m4a');
                  file.createSync();
                  snapshot.addMusicItemToDownloadList(musicItem.musicId);
                  ApiRequest.download(
                    uri: musicUrl,
                    savePath: file.path,
                    onReceiveProgress: (count, total) {
                      snapshot.updateDownloadProgressForMusicItem(
                        musicItem.musicId,
                        count / total,
                      );
                    },
                    cancelToken: snapshot.getCancelToken(musicItem.musicId),
                  );
                  Fluttertoast.showToast(msg: 'Downloading music item...');
                }
              } else {
                Fluttertoast.showToast(msg: 'Please enable storage access');
              }
            } catch (err) {
              log('$err');
              Fluttertoast.showToast(msg: 'Unable to download music item');
            }
          },
          icon: snapshot
                      .getMusicItemDownloadState(musicItem.musicId)
                      ?.downloadStatus ==
                  DownloadStatus.progress
              ? Transform.scale(
                  scale: 0.8,
                  child: GestureDetector(
                    onTap: () {
                      snapshot.cancelDownloadForMusicItem(musicItem.musicId);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.square_fill,
                          size: 12,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: Theme.of(context).dividerColor,
                          value: snapshot
                              .getMusicItemDownloadState(musicItem.musicId)
                              ?.progress,
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 2,
                        ),
                      ],
                    ),
                  ),
                )
              : Icon(
                  CupertinoIcons.arrow_down,
                  color: Theme.of(context).hintColor,
                ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final void Function(String) addMusicItemToDownloadList;
  final void Function(String, double) updateDownloadProgressForMusicItem;
  final void Function(String) cancelDownloadForMusicItem;
  final MusicItemForDownload? Function(String) getMusicItemDownloadState;
  final CancelToken Function(String) getCancelToken;
  _ViewModel({
    required this.addMusicItemToDownloadList,
    required this.updateDownloadProgressForMusicItem,
    required this.cancelDownloadForMusicItem,
    required this.getMusicItemDownloadState,
    required this.getCancelToken,
  });
}

class _Factory extends VmFactory<AppState, MusicTileDownloadButton> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(getMusicItemDownloadState: (musicId) {
      final idx = state.downloadState.musicItemDownloadList
          .indexWhere((element) => element.musicId == musicId);
      if (idx != -1) {
        return state.downloadState.musicItemDownloadList
            .firstWhere((element) => element.musicId == musicId);
      }
    }, cancelDownloadForMusicItem: (musicId) {
      dispatch(CancelDownloadForMusicItem(musicId: musicId));
    }, updateDownloadProgressForMusicItem: (musicId, progress) {
      dispatch(UpdateMusicItemDownloadProgress(
          musicId: musicId, progress: progress));
    }, addMusicItemToDownloadList: (musicId) {
      dispatch(AddMusicItemToDownload(musicId: musicId));
    }, getCancelToken: (musicId) {
      return state.downloadState.musicItemDownloadList
          .firstWhere((element) => element.musicId == musicId)
          .cancelToken;
    });
  }
}
