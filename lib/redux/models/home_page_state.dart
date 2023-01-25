// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:music_player/redux/models/music_item.dart';
import 'package:music_player/utils/update_model.dart';

import '../../utils/constants.dart';

class HomePageState {
  final List<MusicItem> homePageMusicList;
  final List<MusicItem> recentlyPlayedMusicList;
  final LoadingState homepageMusicListLoading;
  final LoadingState homepageNextMusicListLoading;
  final UpdateModel updateModel;
  HomePageState({
    required this.homePageMusicList,
    required this.recentlyPlayedMusicList,
    required this.homepageMusicListLoading,
    required this.homepageNextMusicListLoading,
    required this.updateModel,
  });

  HomePageState copyWith({
    List<MusicItem>? homePageMusicList,
    List<MusicItem>? recentlyPlayedMusicList,
    LoadingState? homepageMusicListLoading,
    LoadingState? homepageNextMusicListLoading,
    UpdateModel? updateModel,
  }) {
    return HomePageState(
      homePageMusicList: homePageMusicList ?? this.homePageMusicList,
      recentlyPlayedMusicList:
          recentlyPlayedMusicList ?? this.recentlyPlayedMusicList,
      homepageMusicListLoading:
          homepageMusicListLoading ?? this.homepageMusicListLoading,
      homepageNextMusicListLoading:
          homepageNextMusicListLoading ?? this.homepageNextMusicListLoading,
      updateModel: updateModel ?? this.updateModel,
    );
  }

  factory HomePageState.initial() {
    return HomePageState(
      homePageMusicList: [],
      homepageMusicListLoading: LoadingState.idle,
      recentlyPlayedMusicList: [],
      homepageNextMusicListLoading: LoadingState.idle,
      updateModel: UpdateModel.init(),
    );
  }

  @override
  String toString() {
    return 'HomePageState(homePageMusicList: $homePageMusicList, recentlyPlayedMusicList: $recentlyPlayedMusicList, homepageMusicListLoading: $homepageMusicListLoading, homepageNextMusicListLoading: $homepageNextMusicListLoading, updateModel: $updateModel)';
  }

  @override
  bool operator ==(covariant HomePageState other) {
    if (identical(this, other)) return true;

    return listEquals(other.homePageMusicList, homePageMusicList) &&
        listEquals(other.recentlyPlayedMusicList, recentlyPlayedMusicList) &&
        other.homepageMusicListLoading == homepageMusicListLoading &&
        other.homepageNextMusicListLoading == homepageNextMusicListLoading &&
        other.updateModel == updateModel;
  }

  @override
  int get hashCode {
    return homePageMusicList.hashCode ^
        recentlyPlayedMusicList.hashCode ^
        homepageMusicListLoading.hashCode ^
        homepageNextMusicListLoading.hashCode ^
        updateModel.hashCode;
  }
}
