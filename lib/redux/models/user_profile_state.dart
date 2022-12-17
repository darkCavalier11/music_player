// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:music_player/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileState {
  final String userName;
  final String profilePicPlatformPath;
  final bool isOnBoardingDone;
  UserProfileState({
    required this.userName,
    required this.profilePicPlatformPath,
    required this.isOnBoardingDone,
  });

  factory UserProfileState.initial() {
    return UserProfileState(
      userName: '',
      profilePicPlatformPath: '',
      isOnBoardingDone: false,
    );
  }

  Future<UserProfileState> fromSharedPref() async {
    final pref = await SharedPreferences.getInstance();
    return UserProfileState(
      userName: pref.getString(SharedPrefKeys.userProfileUsername) ?? '',
      profilePicPlatformPath:
          pref.getString(SharedPrefKeys.userProfileprofilePicPlatformPath) ??
              '',
      isOnBoardingDone:
          pref.getBool(SharedPrefKeys.userProfileisOnBoardingDone) ?? false,
    );
  }

  UserProfileState copyWith({
    String? userName,
    String? profilePicPlatformPath,
    bool? isOnBoardingDone,
  }) {
    return UserProfileState(
      userName: userName ?? this.userName,
      profilePicPlatformPath:
          profilePicPlatformPath ?? this.profilePicPlatformPath,
      isOnBoardingDone: isOnBoardingDone ?? this.isOnBoardingDone,
    );
  }

  @override
  String toString() =>
      'UserProfileState(userName: $userName, profilePicPlatformPath: $profilePicPlatformPath, isOnBoardingDone: $isOnBoardingDone)';

  @override
  bool operator ==(covariant UserProfileState other) {
    if (identical(this, other)) return true;

    return other.userName == userName &&
        other.profilePicPlatformPath == profilePicPlatformPath &&
        other.isOnBoardingDone == isOnBoardingDone;
  }

  @override
  int get hashCode =>
      userName.hashCode ^
      profilePicPlatformPath.hashCode ^
      isOnBoardingDone.hashCode;
}
