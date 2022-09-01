import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabse {
  static late Database mainDb;

  /// Need to call the intialise the static [Database] variable.
  static Future<void> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = dir.path + 'app_main.db';
      mainDb = await databaseFactoryIo.openDatabase(dbPath);
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }
}
