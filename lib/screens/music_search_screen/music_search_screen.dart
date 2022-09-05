// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
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
import 'package:music_player/screens/music_search_result_screen/music_search_result_screen.dart';
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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      onDispose: (store) {
        store.dispatch(OnChangeSearchQueryAction(query: ''));
      },
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
                        loadingState: snapshot.currentSeacrhState,
                        textEditingController: _textEditingController
                          ..addListener(() {
                            if (_debounce?.isActive ?? false) {
                              _debounce?.cancel();
                            }
                            _debounce =
                                Timer(const Duration(milliseconds: 500), () {
                              snapshot.changeSearchQuery(
                                  _textEditingController.text);
                            });
                          }),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _textEditingController.text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    onTap: () {
                      snapshot.onTapSearchResult(_textEditingController.text);
                      Navigator.of(context)
                          .popAndPushNamed(MusicSearchResultScreen.routeName);
                    },
                  ),
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
                            snapshot.onTapSearchResult(
                                snapshot.searchResults[index]);
                            Navigator.of(context).popAndPushNamed(
                                MusicSearchResultScreen.routeName);
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
  final void Function(String) onTapSearchResult;
  _ViewModel({
    required this.query,
    required this.changeSearchQuery,
    required this.currentSeacrhState,
    required this.searchResults,
    required this.onTapSearchResult,
  }) : super(equals: [query, currentSeacrhState, searchResults]);

  @override
  bool operator ==(covariant _ViewModel other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        other.changeSearchQuery == changeSearchQuery &&
        other.currentSeacrhState == currentSeacrhState &&
        listEquals(other.searchResults, searchResults) &&
        other.onTapSearchResult == onTapSearchResult;
  }

  @override
  int get hashCode {
    return query.hashCode ^
        changeSearchQuery.hashCode ^
        currentSeacrhState.hashCode ^
        searchResults.hashCode ^
        onTapSearchResult.hashCode;
  }
}

class _Factory extends VmFactory<AppState, _MusicSearchScreenState> {
  _Factory(widget) : super(widget);

  @override
  _ViewModel fromStore() {
    return _ViewModel(
      onTapSearchResult: (query) {
        dispatch(GetMusicItemFromQueryAction(searchQuery: query));
      },
      searchResults: state.searchState.musicSearchResults.searchResults,
      query: state.searchState.query,
      changeSearchQuery: (query) {
        dispatch(OnChangeSearchQueryAction(query: query));
      },
      currentSeacrhState: state.searchState.currentSeacrhState,
    );
  }
}
