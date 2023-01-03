// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:music_player/main.dart';
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
                  description:
                      'Based on your music playing item, it will cache most played items',
                  title: 'Intelligent Cache',
                  onChanged: (v) {},
                ),
                const Spacer(),
                Text('v' + appVersion),
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
  _ViewModel({
    required this.userName,
  }) : super(equals: [userName]);
}

class _Factory extends VmFactory<AppState, AccountScreen> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      userName: state.userProfileState.userName,
    );
  }
}

class AccountTileSwitch extends StatelessWidget {
  final String title;
  final void Function(bool) onChanged;
  final String description;
  const AccountTileSwitch({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.description,
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
                  value: true,
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
