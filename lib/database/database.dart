
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:my_app_3/database/tables/app_settings.dart';
import 'package:my_app_3/database/tables/expense.dart';
import 'package:my_app_3/database/tables/expense_tag.dart';
import 'package:my_app_3/database/tables/scheduled_expense.dart';
import 'package:my_app_3/database/tables/scheduled_expense_tag.dart';
import 'package:my_app_3/database/tables/tag.dart';
import 'package:my_app_3/database/views/expense_list_view.dart';
import 'package:my_app_3/database/views/expense_month_summary_view.dart';
import 'package:my_app_3/database/views/expense_months_view.dart';
import 'package:path/path.dart' as path;

import 'daos/app_settings_dao.dart';
import 'daos/expense_dao.dart';
import 'daos/scheduled_expenses_dao.dart';
import 'daos/tag_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Tag,
    Expense,
    ExpenseTag,
    AppSetting,
    ScheduledExpense,
    ScheduledExpenseTag,
  ],
  daos: [
    TagDao,
    ExpenseDao,
    AppSettingDao,
    ScheduledExpenseDao
  ],
  views: [
    ExpenseListView,
    ExpenseMonthSummaryView,
    ExpenseMonthsView,
  ]
)
class AppDatabase extends _$AppDatabase {
  static late AppDatabase instance;

  static late TagDao tagsDao;
  static late ExpenseDao expensesDao;
  static late AppSettingDao appSettingsDao;
  static late ScheduledExpenseDao scheduledExpensesDao;

  AppDatabase() : super(_openDbConnection()){
    tagsDao = TagDao(this);
    expensesDao = ExpenseDao(this);
    appSettingsDao = AppSettingDao(this);
    scheduledExpensesDao = ScheduledExpenseDao(this);
  }

  @override
  int get schemaVersion => 1;

  Future<int> nukeDatabase() async {
    int c = await expenseTag.deleteAll();
    c += await scheduledExpenseTag.deleteAll();
    c += await tag.deleteAll();
    c += await expense.deleteAll();
    c += await scheduledExpense.deleteAll();
    return c;
  }

  static QueryExecutor _openDbConnection(){
    const String dbName = "my-app-3-db";
    if(Platform.isAndroid){
      return driftDatabase(name: dbName);
    } else if(Platform.isLinux || Platform.isWindows || Platform.isFuchsia){
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final dbPath = path.join(exeDir, dbName);
      return NativeDatabase.createInBackground(File(dbPath));
    } else {
      throw 'Unsupported platform';
    }
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
