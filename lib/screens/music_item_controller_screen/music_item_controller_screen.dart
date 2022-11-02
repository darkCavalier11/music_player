// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';

class MusicListItemControllerScreen extends StatelessWidget {
  const MusicListItemControllerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 35,
                ),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor.withOpacity(0.1),
                  ),
                ),
              ),
              CarouselSlider(
                items: List.generate(snapshot.nexMusicList.length + 1, (index) {
                  return Container(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                index == 0
                                    ? snapshot.selectedMusicItem!.imageUrl
                                    : snapshot.nexMusicList[index - 1].imageUrl,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).disabledColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                              Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).disabledColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                options: CarouselOptions(
                  pageSnapping: false,
                  viewportFraction: 0.5,
                  scrollPhysics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  padEnds: true,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final List<MusicItem> nexMusicList;
  final MusicItem? selectedMusicItem;
  _ViewModel({
    required this.nexMusicList,
    required this.selectedMusicItem,
  }) : super(equals: [nexMusicList]);
}

class _Factory extends VmFactory<AppState, MusicListItemControllerScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      nexMusicList: state.audioPlayerState.nextMusicList,
      selectedMusicItem: state.audioPlayerState.selectedMusic,
    );
  }
}
