// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/redux_exception.dart';

import '../../utils/shared_pref.dart';
import '../models/user_profile_state.dart';

class LoadUserProfileFromSharedPref extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final userProfileState = UserProfileState(
        userName: pref.getString(SharedPrefKeys.userProfileUsername) ?? '',
        profilePicPlatformPath:
            pref.getString(SharedPrefKeys.userProfileprofilePicPlatformPath) ??
                '',
        isOnBoardingDone:
            pref.getBool(SharedPrefKeys.userProfileisOnBoardingDone) ?? false,
        intelligentCache:
            pref.getBool(SharedPrefKeys.userProfileIntelligentCache) ?? true,
      );
      return state.copyWith(
        userProfileState: userProfileState,
      );
    } catch (err) {
      throw ReduxException(
        errorMessage: err.toString(),
        actionName: 'LoadUserProfileFromSharedPref',
      );
    }
  }
}

class ToggleIntelligentCacheAction extends ReduxAction<AppState> {
  final bool intelligentCache;
  ToggleIntelligentCacheAction({
    required this.intelligentCache,
  });
  @override
  Future<AppState?> reduce() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(
        SharedPrefKeys.userProfileIntelligentCache, intelligentCache);
    return state.copyWith(
      userProfileState: state.userProfileState.copyWith(
        intelligentCache: intelligentCache,
      ),
    );
  }
}
