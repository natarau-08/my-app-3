
import 'dart:async';
import 'dart:io';

import 'package:floor/floor.dart';
import 'package:my_app_3/app_assets.dart';
import 'package:my_app_3/floor/daos/app_settings_dao.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/expense_dao.dart';
import 'daos/scheduled_expense_dao.dart';
import 'daos/tag_dao.dart';
import 'daos/tag_tracking_dao.dart';
import 'tables/app_settings.dart';
import 'tables/expense.dart';
import 'tables/expense_tag.dart';
import 'tables/scheduled_expense.dart';
import 'tables/scheduled_expense_tag.dart';
import 'tables/tag.dart';
import 'tables/tag_tracking.dart';
import 'type_converters/color_tc.dart';
import 'type_converters/date_time_tc.dart';
import 'views/expense_list_view.dart';
import 'views/expense_month_summary_view.dart';
import 'views/expense_months_view.dart';

part 'app_database.g.dart';

@Database(
  version: 2,
  entities: [
    AppSettings,
    Expense,
    Tag,
    ExpenseTag,
    ScheduledExpense,
    ScheduledExpenseTag,
    TagTracking,
  ],
  views: [
    ExpenseListView,
    ExpenseMonthsView,
    ExpenseMonthSummaryView,
  ]
)
@TypeConverters([DateTimeTc, DateTimeTc2, ColorTcN])
abstract class AppDatabase extends FloorDatabase {
  static const dbFileName = 'my-app.db';
  static late AppDatabase instance;

  AppSettingsDao get appSettingsDao;
  ExpenseDao get expenseDao;
  TagDao get tagDao;
  ScheduledExpenseDao get scheduledExpenseDao;
  TagTrackingDao get tagTrackingDao;

  static Future<void> initialize() async {
    String dbName = dbFileName;

    if(Platform.isWindows || Platform.isLinux || Platform.isFuchsia){
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final dbPath = path.join(exeDir, dbName);
      dbName = dbPath;
    }else if(!Platform.isAndroid && !Platform.isIOS){
      throw 'Platform not supported.';
    }

    instance = await $FloorAppDatabase
      .databaseBuilder(dbName)
      .addCallback(Callback(
        onCreate: (database, version) async {
          await database.execute('PRAGMA foreign_keys = ON;');
        }
      ))
      .addMigrations([
        Migration(1, 2, (database) async {
          final sql = await AppAssets.loadSql('migrations/1-2.sql');
          await database.execute(sql);
        })
      ])
      .build();
  }

  static Future<void> nukeDatabase() async {
    final path = instance.database.database.path;
    await instance.close();
    final f = File(path);
    if(await f.exists()){
      await f.delete();
    }else{
      throw 'Error while finding database file.';
    }

    await initialize();
  }
}

