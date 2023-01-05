import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  final String? buttonText;
  final IconData? trailingIcon;
  final void Function() onTap;
  final bool disabled;
  const AppPrimaryButton({
    Key? key,
    this.buttonText,
    required this.onTap,
    this.trailingIcon,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: disabled
              ? Theme.of(context).disabledColor.withOpacity(0.1)
              : Theme.of(context).primaryColor.withOpacity(0.1),
          border: Border.all(
            color: Theme.of(context).disabledColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (buttonText != null) ...[
              Text(
                buttonText!,
                style: Theme.of(context).textTheme.button?.copyWith(
                      color: disabled
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).primaryColor,
                    ),
              ),
            ],
            if (trailingIcon != null && buttonText != null)
              const SizedBox(width: 10),
            if (trailingIcon != null)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  trailingIcon,
                  key: ValueKey<int>(trailingIcon?.codePoint ?? 0),
                  size: 18,
                  color: disabled
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
