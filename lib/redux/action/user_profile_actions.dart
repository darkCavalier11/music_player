import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/redux_exception.dart';
import 'package:music_player/screens/app_page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
