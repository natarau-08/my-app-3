
import 'dart:async';
import 'dart:io';

import 'package:floor/floor.dart';
import 'package:my_app_3/app_assets.dart';
import 'package:my_app_3/floor/daos/app_settings_dao.dart';
import 'package:my_app_3/floor/daos/car_dao.dart';
import 'package:my_app_3/floor/daos/car_repair_dao.dart';
import 'package:my_app_3/floor/daos/car_revision_dao.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/floor/tables/car_repair.dart';
import 'package:my_app_3/floor/tables/car_revision.dart';
import 'package:my_app_3/floor/tables/car_revision_type.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/expense_dao.dart';
import 'daos/scheduled_expense_dao.dart';
import 'daos/tag_dao.dart';
import 'tables/app_settings.dart';
import 'tables/expense.dart';
import 'tables/expense_tag.dart';
import 'tables/scheduled_expense.dart';
import 'tables/scheduled_expense_tag.dart';
import 'tables/tag.dart';
import 'type_converters/color_tc.dart';
import 'type_converters/date_time_tc.dart';
import 'views/expense_list_view.dart';
import 'views/expense_month_summary_view.dart';
import 'views/expense_months_view.dart';

part 'app_database.g.dart';

@Database(
  version: 3,
  entities: [
    AppSettings,
    Expense,
    Tag,
    ExpenseTag,
    ScheduledExpense,
    ScheduledExpenseTag,

    Car,
    CarRevisionType,
    CarRevision,
    CarRepair,
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

  static String get dbPath => instance.database.database.path;

  AppSettingsDao get appSettingsDao;
  ExpenseDao get expenseDao;
  TagDao get tagDao;
  ScheduledExpenseDao get scheduledExpenseDao;

  CarDao get carDao;
  CarRevisionDao get carRevisionDao;
  CarRepairDao get carRepairDao;

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
        await AppAssets.loadMigration(1, 2),
        await AppAssets.loadMigration(2, 3),
      ])
      .build();
  }

  static Future<void> nukeDatabase() async {
    await instance.close();
    final f = File(dbPath);
    if(await f.exists()){
      await f.delete();
    }else{
      throw 'Error while finding database file.';
    }
  }
}

