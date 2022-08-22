// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/models/search_state.dart';
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
        log(snapshot.currentSeacrhState.toString());
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
                  if (snapshot.currentSeacrhState == LoadingState.loading)
                    LoadingIndicator.small(context),
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        final searchWords = snapshot.query.split(' ');
                        final currentSearchResult =
                            snapshot.searchResults[index].split(' ');
                        List<TextSpan> displayText = [];
                        if (snapshot.searchResults[index]
                            .contains(snapshot.query)) {
                          final searchString = snapshot.query;
                          final resultString = snapshot.searchResults[index];
                          final highlightPart = resultString.substring(
                              resultString.indexOf(searchString),
                              resultString.indexOf(searchString) +
                                  searchString.length);
                          final nonHighlightPartLeft = resultString.substring(
                                  0, resultString.indexOf(searchString)),
                              nonHighlightPartRight = resultString.substring(
                                  resultString.indexOf(searchString) +
                                      searchString.length);
                          displayText.add(TextSpan(
                              text: nonHighlightPartLeft,
                              style: Theme.of(context).textTheme.bodyLarge));
                          displayText.add(TextSpan(
                              text: highlightPart,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )));
                          displayText.add(TextSpan(
                              text: nonHighlightPartRight,
                              style: Theme.of(context).textTheme.bodyLarge));
                        } else {
                          for (var w1 in currentSearchResult) {
                            if (searchWords.contains(w1)) {
                              displayText.add(
                                TextSpan(
                                  text: w1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              );
                            } else {
                              displayText.add(TextSpan(
                                  text: w1,
                                  style:
                                      Theme.of(context).textTheme.bodyText1));
                            }
                            displayText.add(const TextSpan(text: ' '));
                          }
                        }

                        return ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: RichText(
                              text: TextSpan(children: displayText),
                            ),
                          ),
                          onTap: () {
                            log(displayText.toString());
                          },
                        );
                      },
                      itemCount: snapshot.searchResults.length,
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
  final LoadingState currentSeacrhState;
  final List<String> searchResults;
  _ViewModel({
    required this.query,
    required this.changeSearchQuery,
    required this.currentSeacrhState,
    required this.searchResults,
  }) : super(equals: [query, currentSeacrhState, searchResults]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        other.changeSearchQuery == changeSearchQuery &&
        other.currentSeacrhState == currentSeacrhState &&
        listEquals(other.searchResults, searchResults);
  }

  @override
  int get hashCode {
    return query.hashCode ^
        changeSearchQuery.hashCode ^
        currentSeacrhState.hashCode ^
        searchResults.hashCode;
  }
}

class _Factory extends VmFactory<AppState, _MusicSearchScreenState> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      searchResults: state.searchState.musicSearchResults.searchResults,
      query: state.searchState.query,
      changeSearchQuery: (query) {
        dispatch(OnChangeSearchQueryAction(query: query));
      },
      currentSeacrhState: state.searchState.currentSeacrhState,
    );
  }
}
