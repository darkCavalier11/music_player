// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/main.dart';
import 'package:music_player/redux/action/user_profile_actions.dart';
import 'package:music_player/screens/onboarding/onboarding.dart';

import '../../redux/models/app_state.dart';
import '../../widgets/text_themes/app_header_text.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
            child: Column(
              children: [
                const AppHeaderText(
                  icon: Iconsax.timer_1,
                  text: 'My Account',
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: CircleAvatar(
                        backgroundImage:
                            FileImage(File(snapshot.profilePicPlatformPath)),
                        radius: 35,
                        child: Text(
                          snapshot.userName[0],
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Theme.of(context).cardColor,
                                  ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 6,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const OnboardingScreen()));
                        },
                        icon: Icon(
                          CupertinoIcons.pencil_circle_fill,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  snapshot.userName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                AccountTileSwitch(
                  value: snapshot.intelligentCache,
                  description:
                      'Based on your music playing item, it will cache most played items',
                  title: 'Intelligent Cache',
                  onChanged: (v) {
                    snapshot.toggleIntelligentCache(v);
                  },
                ),
                const Spacer(),
                Text('v' + appVersion + ' (Beta)'),
                Text(
                  'Made with ❤️ in 🇮🇳',
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final String userName;
  final String profilePicPlatformPath;
  final bool intelligentCache;
  final Future<void> Function(bool) toggleIntelligentCache;
  _ViewModel({
    required this.userName,
    required this.intelligentCache,
    required this.profilePicPlatformPath,
    required this.toggleIntelligentCache,
  }) : super(equals: [userName, intelligentCache]);
}

class _Factory extends VmFactory<AppState, AccountScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      userName: state.userProfileState.userName,
      profilePicPlatformPath: state.userProfileState.profilePicPlatformPath,
      intelligentCache: state.userProfileState.intelligentCache,
      toggleIntelligentCache: (intelligentCache) async {
        dispatch(
            ToggleIntelligentCacheAction(intelligentCache: intelligentCache));
      },
    );
  }
}

class AccountTileSwitch extends StatelessWidget {
  final String title;
  final void Function(bool) onChanged;
  final String description;
  final bool value;
  const AccountTileSwitch({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.description,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(title),
                const Spacer(),
                CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                )
              ],
            ),
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
