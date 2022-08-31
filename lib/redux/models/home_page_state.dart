// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/search_state.dart';

class HomePageState {
  final List<MusicItem> homePageMusicList;
  final LoadingState homepageMusicListLoading;
  HomePageState({
    required this.homePageMusicList,
    required this.homepageMusicListLoading,
  });

  HomePageState copyWith({
    List<MusicItem>? homePageMusicList,
    LoadingState? homepageMusicListLoading,
  }) {
    return HomePageState(
      homePageMusicList: homePageMusicList ?? this.homePageMusicList,
      homepageMusicListLoading:
          homepageMusicListLoading ?? this.homepageMusicListLoading,
    );
  }

  factory HomePageState.initial() {
    return HomePageState(
      homePageMusicList: [],
      homepageMusicListLoading: LoadingState.idle,
    );
  }

  @override
  String toString() =>
      'HomePageState(homePageMusicList: $homePageMusicList, homepageMusicListLoading: $homepageMusicListLoading)';

  @override
  bool operator ==(covariant HomePageState other) {
    if (identical(this, other)) return true;

    return listEquals(other.homePageMusicList, homePageMusicList) &&
        other.homepageMusicListLoading == homepageMusicListLoading;
  }

  @override
  int get hashCode =>
      homePageMusicList.hashCode ^ homepageMusicListLoading.hashCode;
}
