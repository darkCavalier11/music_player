import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:music_player/screens/home_page/widgets/bottom_navigation_cluster.dart';
import 'package:music_player/utils/swatch_generator.dart';

import '../../redux/action/ui_action.dart';
import '../../redux/models/app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: snapshot.uiState.themeMode == ThemeMode.light
              ? Colors.white
              : Colors.black,
          body: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(CupertinoIcons.search),
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.07),
                        filled: true,
                        hintText: 'Search songs, artist & genres...',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Iconsax.music,
                          size: 35,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Recently played',
                          style: Theme.of(context).textTheme.button?.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
                BottomNavigationCluster()
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final UiState uiState;
  final Function() toggleTheme;
  _ViewModel({
    required this.uiState,
    required this.toggleTheme,
  }) : super(equals: [uiState]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ViewModel &&
        other.uiState == uiState &&
        other.toggleTheme == toggleTheme;
  }

  @override
  int get hashCode => uiState.hashCode ^ toggleTheme.hashCode;
}

class _Factory extends VmFactory<AppState, HomePage> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      uiState: state.uiState,
      toggleTheme: () {
        if (state.uiState.themeMode == ThemeMode.dark) {
          dispatch(ChangeThemeAction(themeMode: ThemeMode.light));
        } else {
          dispatch(ChangeThemeAction(themeMode: ThemeMode.dark));
        }
      },
    );
  }
}
