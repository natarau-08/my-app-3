
import 'package:flutter/services.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/utils.dart';

sealed class ReportCtSql {
  static Future<List<Map<String, dynamic>>> mReportCt(DateTime startTime, DateTime endTime) async {
    final db = AppDatabase.instance.database.database;

    return await db.rawQuery(
      await rootBundle.loadString('assets/sql/report_ct.sql'),
      [startTime.toIso8601String(),
      endTime.toIso8601String()]
    ) as List<Map<String, dynamic>>;
  }

  static Future<List<Map<String, dynamic>>> reportCtMonthly(int year, int month) {
    final startDate = DateTime(year, month, 1);
    final endDate = Utils.addMonths(startDate, 1);
    return mReportCt(startDate, endDate);
  }
}