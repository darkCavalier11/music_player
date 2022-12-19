// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:async_redux/async_redux.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetUsernameAction extends ReduxAction<AppState> {
  final String userName;
  SetUsernameAction({
    required this.userName,
  });

  @override
  Future<AppState> reduce() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.userProfileUsername, userName);
    return state.copyWith(
      userProfileState: state.userProfileState.copyWith(
        userName: userName,
      ),
    );
  }
}

class SetOnboardingDoneAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefKeys.userProfileisOnBoardingDone, true);
    return state.copyWith(
      userProfileState: state.userProfileState.copyWith(
        isOnBoardingDone: true,
      ),
    );
  }
}

class SetProfilePicPlatformPathAction extends ReduxAction<AppState> {
  final String profilePicPlatformPath;
  SetProfilePicPlatformPathAction({
    required this.profilePicPlatformPath,
  });
  @override
  Future<AppState> reduce() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.userProfileprofilePicPlatformPath,
        profilePicPlatformPath);
    return state.copyWith(
      userProfileState: state.userProfileState.copyWith(
        profilePicPlatformPath: profilePicPlatformPath,
      ),
    );
  }
}
