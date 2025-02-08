
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/utils.dart';

sealed class ReportCtSql {
  static Future<List<Map<String, dynamic>>> mReportCt(DateTime startTime, DateTime endTime) async {
    final db = AppDatabase.instance.database.database;

    return await db.rawQuery('''
select
  ROW_NUMBER() OVER(order by case when t.name is null then 1 else 0 end, t.name) as `crtNo`,
  t.name as `tagName`,
  SUM(case when e.value > 0 then e.value else 0 end) as `loss`,
  SUM(case when e.value < 0 then e.value else 0 end) as `gain`,
  SUM(e.value) as `total`
from expenses e
left join expense_tags et on et.expense_id=e.id
left join tags t on t.id=et.tag_id
where e.created_date >= ? and e.created_date < ?
GROUP BY t.name
ORDER BY `crtNo`
''', [startTime.toIso8601String(), endTime.toIso8601String()]) as List<Map<String, dynamic>>;
  }

  static Future<List<Map<String, dynamic>>> reportCtMonthly(int year, int month) {
    final startDate = DateTime(year, month, 1);
    final endDate = Utils.addMonths(startDate, 1);
    return mReportCt(startDate, endDate);
  }
}