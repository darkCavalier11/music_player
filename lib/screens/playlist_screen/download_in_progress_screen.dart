// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/download_state.dart';
import 'package:music_player/utils/constants.dart';

class DownloadInProgressScreen extends StatelessWidget {
  const DownloadInProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 64),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.arrow_down_circle,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'My Downloads',
                    style: Theme.of(context).textTheme.button?.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
              Expanded(
                child: snapshot.musicItemDownloadList.isEmpty
                    ? Center(
                        child: Text(
                          'No downloads in progress',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final musicItemForDownload =
                              snapshot.musicItemDownloadList[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                foregroundImage: CachedNetworkImageProvider(
                                    musicItemForDownload.musicItem.imageUrl),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        musicItemForDownload.musicItem.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                      ),
                                      Text(
                                        musicItemForDownload.musicItem.author,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color:
                                                  Theme.of(context).cardColor,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: LinearProgressIndicator(
                                          value: musicItemForDownload.progress,
                                          color: Theme.of(context).primaryColor,
                                          backgroundColor:
                                              Theme.of(context).focusColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Spacer(),
                                          Text(
                                            (musicItemForDownload.progress *
                                                        100)
                                                    .toStringAsFixed(1) +
                                                '%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: snapshot.musicItemDownloadList.length,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, DownloadInProgressScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel? fromStore() {
    return _ViewModel(
      musicItemDownloadList: state.downloadState.musicItemDownloadList
          .where((element) => element.downloadStatus == DownloadStatus.progress)
          .toList(),
    );
  }
}

class _ViewModel extends Vm {
  final List<MusicItemForDownload> musicItemDownloadList;
  _ViewModel({
    required this.musicItemDownloadList,
  }) : super(equals: [musicItemDownloadList]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.musicItemDownloadList, musicItemDownloadList);
  }

  @override
  int get hashCode => musicItemDownloadList.hashCode;
}
