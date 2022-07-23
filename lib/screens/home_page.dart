import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../redux/action/ui_action.dart';
import '../redux/models/app_state.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        snapshot.toggleTheme();
                      },
                      child: snapshot.uiState.themeMode == ThemeMode.dark
                          ? const Icon(CupertinoIcons.moon_stars)
                          : const Icon(CupertinoIcons.sun_max),
                    )
                  ],
                ),
                Text(
                  'Library',
                  style: Theme.of(context).textTheme.button?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.search),
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.07),
                    filled: true,
                    hintText: 'Search songs, artist & genres...',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
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
