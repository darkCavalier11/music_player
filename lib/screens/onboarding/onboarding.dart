import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/widgets/app_back_button.dart';
import 'package:music_player/widgets/app_primary_button.dart';
import 'package:music_player/widgets/app_text_field.dart';
import 'package:music_player/widgets/music_playing_wave_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).cardColor,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).dividerColor,
                    radius: 80,
                  ),
                  const SizedBox(height: 40),
                  AppTextField(
                    hintText: 'Enter Your Name',
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      AppPrimaryButton(
                        onTap: () {},
                        buttonText: 'Let\'s Go',
                        trailingIcon: Icons.arrow_circle_right,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
