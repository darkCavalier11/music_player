// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/screens/home_screen/widgets/search_text_field.dart';
import 'package:music_player/screens/music_search_screen/actions/search_actions.dart';
import 'package:music_player/utils/loading_indicator.dart';

class MusicSearchScreen extends StatefulWidget {
  const MusicSearchScreen({Key? key}) : super(key: key);

  static const routeScreen = "/musicSearchScreen";

  @override
  State<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends State<MusicSearchScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
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
      builder: (context, snapshot) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: () {
            Navigator.of(context).pop();
          }),
          body: Material(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 64,
                    ),
                    child: Hero(
                      tag: 'search',
                      child: SearchTextField(
                        textEditingController: _textEditingController
                          ..addListener(() {
                            snapshot
                                .changeSearchQuery(_textEditingController.text);
                          }),
                      ),
                    ),
                  ),
                  const Divider(),
                  LoadingIndicator.small(context),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text('Title $index'),
                          ),
                          onTap: () {
                            print('object');
                          },
                        );
                      },
                      itemCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final String query;
  final void Function(String) changeSearchQuery;
  _ViewModel({
    required this.query,
    required this.changeSearchQuery,
  });
}

class _Factory extends VmFactory<AppState, _MusicSearchScreenState> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      query: state.searchState.query,
      changeSearchQuery: (query) {
        dispatch(ChangeSearchQuery(query: query));
      },
    );
  }
}
