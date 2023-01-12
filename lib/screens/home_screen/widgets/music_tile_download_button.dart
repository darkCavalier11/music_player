import 'dart:developer';

import 'package:async_redux/async_redux.dart';
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
              final per = await Permission.storage.request();
              if (per.isGranted) {
                final musicUrl =
                    await ParserHelper.getMusicItemUrl(musicItem.musicId);
                final savePath = await FilePicker.platform.getDirectoryPath();

                if (savePath != null) {
                  snapshot.addMusicItemToDownloadList(musicItem.musicId);
                  ApiRequest.download(
                    uri: musicUrl,
                    savePath: savePath + '/${musicItem.title}.m4a',
                    onReceiveProgress: (count, total) {
                      snapshot.updateDownloadProgressForMusicItem(
                          musicItem.musicId, count / total);
                    },
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
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).dividerColor,
                    value: snapshot
                        .getMusicItemDownloadState(musicItem.musicId)
                        ?.progress,
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 2,
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
  _ViewModel({
    required this.addMusicItemToDownloadList,
    required this.updateDownloadProgressForMusicItem,
    required this.cancelDownloadForMusicItem,
    required this.getMusicItemDownloadState,
  });
}

class _Factory extends VmFactory<AppState, MusicTileDownloadButton> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      getMusicItemDownloadState: (musicId) {
        final idx = state.downloadState.musicItemDownloadList
            .indexWhere((element) => element.musicId == musicId);
        if (idx != -1) {
          return state.downloadState.musicItemDownloadList
              .firstWhere((element) => element.musicId == musicId);
        }
      },
      cancelDownloadForMusicItem: (musicId) {
        dispatch(CancelDownloadForMusicItem(musicId: musicId));
      },
      updateDownloadProgressForMusicItem: (musicId, progress) {
        dispatch(UpdateMusicItemDownloadProgress(
            musicId: musicId, progress: progress));
      },
      addMusicItemToDownloadList: (musicId) {
        dispatch(AddMusicItemToDownload(musicId: musicId));
      },
    );
  }
}
