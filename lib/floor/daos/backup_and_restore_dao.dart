
import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:my_app_3/constants.dart';
import 'package:my_app_3/floor/app_database.dart';

@dao
abstract class BackupAndRestoreDao {
  static const String _version = 'v';
  static const String _tagsCount = 't';
  static const String _expensesCount = 'e';
  static const String _expenseTagsCount = 'et';
  static const String _scheduledExpensesCount = 'se';
  static const String _scheduledExpenseTagsCount = 'set';
  static const String _nl = '\n';

  @Query('select count(*) from tags')
  Future<int?> mTagsCount();

  @Query('select count(*) from expenses')
  Future<int?> mExpensesCount();

  @Query('select count(*) from expense_tags')
  Future<int?> mExpenseTagsCount();

  @Query('select count(*) from scheduled_expenses')
  Future<int?> mScheduledExpensesCount();

  @Query('select count(*) from scheduled_expense_tags')
  Future<int?> mScheduledExpenseTagsCount();

  Stream<String> _streamTable(String name) async* {
    final list = await AppDatabase.instance.database.query(name);
    for(final map in list){
      yield jsonEncode(map);
      yield _nl;
    }
  }

  Stream<String> streamData() async* {
    final tc = await mTagsCount() ?? 0;
    final ec = await mExpensesCount() ?? 0;
    final etc = await mExpenseTagsCount() ?? 0;
    final sec = await mScheduledExpensesCount() ?? 0;
    final setc = await mScheduledExpenseTagsCount() ?? 0;

    // header
    yield jsonEncode({
      _version: Constants.version,
      _tagsCount: tc,
      _expensesCount: ec,
      _expenseTagsCount: etc,
      _scheduledExpensesCount: sec,
      _scheduledExpenseTagsCount: setc,
    });

    yield _nl;

    yield* _streamTable('tags');
    yield* _streamTable('expenses');
    yield* _streamTable('expense_tags');
    yield* _streamTable('scheduled_expenses');
    yield* _streamTable('scheduled_expense_tags');
  }
}