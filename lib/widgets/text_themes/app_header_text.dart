// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppHeaderText extends StatelessWidget {
  final IconData icon;
  final String text;
  const AppHeaderText({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: text,
      child: Row(
        children: [
          Icon(
            icon,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.button?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ],
      ),
    );
  }
}
