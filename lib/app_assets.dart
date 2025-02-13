
import 'package:floor/floor.dart';
import 'package:flutter/services.dart';

sealed class AppAssets {
  static Future<String> loadSql(name) {
    return rootBundle.loadString('assets/sql/$name.sql');
  }

  static Future<Migration> loadMigration(int from, int to) async {
    final sql = await loadSql('migrations/${from}_$to');
    return Migration(from, to, (database) async {
      await database.execute(sql);
    });
  }
}