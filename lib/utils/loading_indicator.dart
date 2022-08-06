import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).dividerColor,
        color: Theme.of(context).primaryColor,
        strokeWidth: 2,
      ),
    );
  }
}
