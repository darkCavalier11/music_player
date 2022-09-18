// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:music_player/redux/action/ui_action.dart';
import 'package:music_player/redux/models/app_state.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, snapshot) => Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Theme.of(context).disabledColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  snapshot.onChange(0);
                },
                child: _BottomNavigationButton(
                  enabledText: 'Home',
                  icon: CupertinoIcons.home,
                  enabled: snapshot.currentBottomNavIndex == 0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  snapshot.onChange(1);
                },
                child: _BottomNavigationButton(
                  enabledText: 'Playlist',
                  icon: Iconsax.music_playlist,
                  enabled: snapshot.currentBottomNavIndex == 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  snapshot.onChange(2);
                },
                child: _BottomNavigationButton(
                  enabledText: 'Account',
                  icon: CupertinoIcons.person,
                  enabled: snapshot.currentBottomNavIndex == 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationButton extends StatelessWidget {
  final IconData icon;
  final String enabledText;
  final bool enabled;
  const _BottomNavigationButton({
    Key? key,
    required this.icon,
    required this.enabledText,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: enabled ? Theme.of(context).primaryColor.withOpacity(0.2) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: enabled
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor,
          ),
          const SizedBox(width: 4),
          if (enabled)
            Text(
              enabledText,
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            )
        ],
      ),
    );
  }
}

class _ViewModel extends Vm {
  final int currentBottomNavIndex;
  final void Function(int) onChange;
  _ViewModel({
    required this.currentBottomNavIndex,
    required this.onChange,
  });
}

class _Factory extends VmFactory<AppState, BottomNavigationWidget> {
  _Factory(widget) : super(widget);
  @override
  _ViewModel fromStore() {
    return _ViewModel(
      currentBottomNavIndex: state.uiState.currentBottomNavIndex,
      onChange: (index) {
        dispatch(ChangeBottomNavIndex(index: index));
      },
    );
  }
}
