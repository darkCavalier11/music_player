import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  const SearchTextField({
    required this.textEditingController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextField(
        autofocus: true,
        cursorColor: Theme.of(context).primaryColor,
        controller: textEditingController,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: Theme.of(context).primaryColor,
          ),
          fillColor: AppConstants.primaryColorLight,
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
