// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/utils/loading_indicator.dart';

import '../../../utils/constants.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final LoadingState loadingState;
  const SearchTextField({
    Key? key,
    required this.textEditingController,
    required this.loadingState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextField(
        autofocus: true,
        cursorColor: Theme.of(context).primaryColor,
        controller: textEditingController,
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
