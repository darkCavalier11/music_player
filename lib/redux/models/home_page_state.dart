// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/redux/models/search_state.dart';

class HomePageState {
  final List<MusicItem> homePageMusicList;
  final List<MusicItem> recentlyPlayedMusicList;
  final LoadingState homepageMusicListLoading;
  final LoadingState homepageNextMusicListLoading;
  HomePageState({
    required this.homePageMusicList,
    required this.recentlyPlayedMusicList,
    required this.homepageMusicListLoading,
    required this.homepageNextMusicListLoading,
  });

  HomePageState copyWith({
    List<MusicItem>? homePageMusicList,
    List<MusicItem>? recentlyPlayedMusicList,
    LoadingState? homepageMusicListLoading,
    LoadingState? homepageNextMusicListLoading,
  }) {
    return HomePageState(
      homePageMusicList: homePageMusicList ?? this.homePageMusicList,
      recentlyPlayedMusicList:
          recentlyPlayedMusicList ?? this.recentlyPlayedMusicList,
      homepageMusicListLoading:
          homepageMusicListLoading ?? this.homepageMusicListLoading,
      homepageNextMusicListLoading:
          homepageNextMusicListLoading ?? this.homepageNextMusicListLoading,
    );
  }

  factory HomePageState.initial() {
    return HomePageState(
      homePageMusicList: [],
      homepageMusicListLoading: LoadingState.idle,
      recentlyPlayedMusicList: [],
      homepageNextMusicListLoading: LoadingState.idle,
    );
  }

  @override
  String toString() {
    return 'HomePageState(homePageMusicList: $homePageMusicList, recentlyPlayedMusicList: $recentlyPlayedMusicList, homepageMusicListLoading: $homepageMusicListLoading, homepageNextMusicListLoading: $homepageNextMusicListLoading)';
  }

  @override
  bool operator ==(covariant HomePageState other) {
    if (identical(this, other)) return true;

    return listEquals(other.homePageMusicList, homePageMusicList) &&
        listEquals(other.recentlyPlayedMusicList, recentlyPlayedMusicList) &&
        other.homepageMusicListLoading == homepageMusicListLoading &&
        other.homepageNextMusicListLoading == homepageNextMusicListLoading;
  }

  @override
  int get hashCode {
    return homePageMusicList.hashCode ^
        recentlyPlayedMusicList.hashCode ^
        homepageMusicListLoading.hashCode ^
        homepageNextMusicListLoading.hashCode;
  }
}
