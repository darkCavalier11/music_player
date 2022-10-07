// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:music_player/redux/models/search_state.dart';
import 'package:music_player/widgets/loading_indicator.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final void Function(String) onSubmitted;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final String hintText;
  const AppTextField({
    Key? key,
    this.textEditingController,
    required this.onSubmitted,
    this.trailingIcon,
    this.leadingIcon,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      child: TextField(
        onSubmitted: onSubmitted,
        cursorColor: Theme.of(context).primaryColor,
        controller: textEditingController,
        decoration: InputDecoration(
          suffixIconConstraints: const BoxConstraints(
            maxHeight: 20,
            maxWidth: 50,
          ),
          isDense: true,
          prefixIcon: leadingIcon != null
              ? Icon(
                  leadingIcon,
                  color: Theme.of(context).primaryColor,
                )
              : null,
          filled: true,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
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
