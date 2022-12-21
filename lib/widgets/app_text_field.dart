// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';


class AppTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool? enabled;
  final String hintText;
  const AppTextField({
    Key? key,
    this.textEditingController,
    this.onSubmitted,
    this.onChanged,
    this.trailingIcon,
    this.leadingIcon,
    this.enabled,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      child: TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.name,
        enabled: enabled,
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
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).disabledColor,
                fontSize: 16,
              ),
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
