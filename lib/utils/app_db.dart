import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDb {
  static Future<Database> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = dir.path + 'app_main.db';
      return databaseFactoryIo.openDatabase(dbPath);
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }
}
