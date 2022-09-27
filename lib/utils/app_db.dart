import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabse {
  static late Database _mainDb;

  /// Need to call the intialise the static [Database] variable.
  /// Most helpful for storing encoded json data.
  static Future<void> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = dir.path + '/app_main.db';
      _mainDb = await databaseFactoryIo.openDatabase(dbPath);
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current, name: 'ErrorLog');
      throw Exception(err);
    }
  }

  static Future<void> setQuery(DbKeys key, String value) async {
    try {
      final store = StoreRef<String, String>.main();
      await store.record(key.toEnumString()).put(_mainDb, value);
    } catch (err) {
      throw ErrorSummary('settQuery failed $key: $value > $err');
    }
  }

  static Future<String?> getQuery(DbKeys key) async {
    try {
      final store = StoreRef<String, String>.main();
      return store.record(key.toEnumString()).get(_mainDb);
    } catch (err) {
      throw ErrorSummary('Error getQuery $key > $err');
    }
  }

  // use with caution.
  static Future<String?> clearDbWithKey(DbKeys key) async {
    try {
      final store = StoreRef<String, String>.main();
      return store.record(key.toEnumString()).delete(_mainDb);
    } catch (err) {
      throw ErrorSummary('Deleting query failed $key > $err');
    }
  }
}

enum DbKeys {
  context,
  recentlyPlayedList,
  searchedItemList,
}

extension on DbKeys {
  String toEnumString() {
    if (this == DbKeys.context) {
      return 'context';
    } else if (this == DbKeys.recentlyPlayedList) {
      return 'recentlyPlayedList';
    } else if (this == DbKeys.searchedItemList) {
      return 'searchItemList';
    } else {
      return '#';
    }
  }
}
