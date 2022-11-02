// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/screens/home_screen/actions/music_actions.dart';
import 'package:music_player/screens/home_screen/widgets/music_player_widget.dart';

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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  child: MusicPlayerWidget(),
                  alignment: Alignment(0, 0),
                ),
              ),
              Align(
                alignment: const Alignment(-0.9, -0.9),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  ),
                ),
              ),
              const Align(
                child: Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                alignment: Alignment(0, -0.2),
              ),
              const Align(
                child: Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                alignment: Alignment(0, 0.2),
              ),
              const Align(
                child: Text('Queue >>'),
                alignment: Alignment(-0.8, 0.3),
              ),
              Align(
                alignment: const Alignment(0, 4),
                child: CarouselSlider(
                  items: List.generate(snapshot.nexMusicList.length, (index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            snapshot.playAudio(snapshot.nexMusicList[index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.network(
                                        snapshot.nexMusicList[index].imageUrl,
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
                                            color:
                                                Theme.of(context).disabledColor,
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
                                            color:
                                                Theme.of(context).disabledColor,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  snapshot.nexMusicList[index].title,
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        snapshot.nexMusicList[index].author,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      flex: 4,
                                    ),
                                    Expanded(
                                      child: Text(snapshot
                                          .nexMusicList[index].duration),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  options: CarouselOptions(
                    aspectRatio: 0.64,
                    pageSnapping: false,
                    viewportFraction: 0.6,
                    scrollPhysics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    padEnds: true,
                  ),
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
  final Future<void> Function(MusicItem) playAudio;
  _ViewModel({
    required this.nexMusicList,
    required this.selectedMusicItem,
    required this.playAudio,
  }) : super(equals: [nexMusicList]);
}

class _Factory extends VmFactory<AppState, MusicListItemControllerScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      playAudio: (musicItem) async {
        dispatch(PlayAudioAction(musicItem: musicItem));
      },
      nexMusicList: state.audioPlayerState.nextMusicList,
      selectedMusicItem: state.audioPlayerState.selectedMusic,
    );
  }
}
