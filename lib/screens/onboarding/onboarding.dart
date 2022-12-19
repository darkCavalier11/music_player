// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/screens/app_page_view.dart';
import 'package:music_player/screens/onboarding/actions/onboarding_actions.dart';
import 'package:music_player/widgets/app_back_button.dart';
import 'package:music_player/widgets/app_primary_button.dart';
import 'package:music_player/widgets/app_text_field.dart';
import 'package:music_player/widgets/music_playing_wave_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              child: Image.asset(
                'assets/images/onboarding_background.jpeg',
                height: MediaQuery.of(context).size.height * 0.26,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              top: 0,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        MusicPlayingWaveWidget(
                          playingStream: Stream.value(true),
                        ),
                        Text(
                          'Listen everything adfree!',
                          style:
                              Theme.of(context).textTheme.headline2?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).cardColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).dividerColor,
                          radius: 80,
                        ),
                        Positioned(
                          child: GestureDetector(
                            child: const Icon(
                              CupertinoIcons.camera_circle,
                              size: 35,
                            ),
                            onTap: () async {
                              try {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  type: FileType.image,
                                );

                                if (result?.files.single.path != null) {
                                  File file = File(result!.files.single.path!);
                                  log('${file.absolute}');
                                } else {}
                              } catch (err) {
                                log('$err');
                              }
                            },
                          ),
                          right: 12,
                          bottom: 12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    AppTextField(
                      hintText: 'Enter Your Name',
                      textEditingController: _textEditingController,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        AppPrimaryButton(
                          onTap: () {},
                          buttonText: 'Let\'s Go',
                          trailingIcon: Icons.arrow_circle_right,
                          disabled: true,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewModel extends Vm {
  final void Function({required String userName}) setUsername;
  final void Function() setOnboardingDone;
  final void Function({required String profilePicPlatformPath})
      setProfilePicPlatformPath;

  final String userName;
  final String profilePicPlatformPath;
  final bool isOnBoardingDone;
  _ViewModel({
    required this.setOnboardingDone,
    required this.userName,
    required this.profilePicPlatformPath,
    required this.isOnBoardingDone,
    required this.setProfilePicPlatformPath,
    required this.setUsername,
  });
}

class _Factory extends VmFactory<AppState, _OnboardingScreenState> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      setProfilePicPlatformPath: ({required String profilePicPlatformPath}) {
        dispatch(SetProfilePicPlatformPathAction(
            profilePicPlatformPath: profilePicPlatformPath));
      },
      setUsername: ({required String userName}) {
        dispatch(SetUsernameAction(userName: userName));
      },
      setOnboardingDone: () {
        dispatch(SetOnboardingDoneAction());
      },
      userName: state.userProfileState.userName,
      profilePicPlatformPath: state.userProfileState.profilePicPlatformPath,
      isOnBoardingDone: state.userProfileState.isOnBoardingDone,
    );
  }
}
