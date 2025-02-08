
import 'package:flutter/services.dart';

sealed class AppAssets {
  static Future<String> loadSql(name) {
    return rootBundle.loadString('assets/sql/$name.sql');
  }
}