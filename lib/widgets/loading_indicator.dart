import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Theme.of(context).dividerColor,
      color: Theme.of(context).primaryColor,
      strokeWidth: 2,
    );
  }

  static Widget small(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 20, maxWidth: 20),
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).dividerColor,
        color: Theme.of(context).primaryColor,
        strokeWidth: 2,
      ),
    );
  }
}
