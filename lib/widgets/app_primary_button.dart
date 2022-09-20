import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  final String buttonText;
  final Widget? trailingIcon;
  const AppPrimaryButton({
    Key? key,
    required this.buttonText,
    this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          border: Border.all(
            color: Theme.of(context).disabledColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonText,
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 10),
            if (trailingIcon != null) trailingIcon!
          ],
        ),
      ),
    );
  }
}