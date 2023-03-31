// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/widgets/loading_indicator.dart';

import '../utils/constants.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final LoadingState loadingState;
  final void Function(String) onSubmitted;
  const SearchTextField({
    Key? key,
    required this.onSubmitted,
    required this.textEditingController,
    required this.loadingState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextField(
        onSubmitted: onSubmitted,
        autofocus: false,
        cursorColor: Theme.of(context).primaryColor,
        controller: textEditingController,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).cardColor,
            ),
        decoration: InputDecoration(
          suffixIcon: loadingState == LoadingState.loading
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: LoadingIndicator.small(
                    context,
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            maxHeight: 20,
            maxWidth: 50,
          ),
          isDense: true,
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: Theme.of(context).primaryColor,
          ),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
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
    );
  }
}
