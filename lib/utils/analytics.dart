import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

class AppAnalytics {
  static final _firebaseAnalytics = FirebaseAnalytics.instance;

  static Future<void> logEvent(
      {required String name, Map<String, Object?>? parameters}) async {
    try {
      _firebaseAnalytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (err) {
      log('Error logging event to firebase : $err');
    }
  }
}
