import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AppUiUtils {
  static Future<T?> appGenericDialog<T>(BuildContext context,
      {Widget? title, Widget? actions}) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: AppConstants.backgroundColorLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) title,
                    const SizedBox(height: 15),
                    if (actions != null) actions,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
