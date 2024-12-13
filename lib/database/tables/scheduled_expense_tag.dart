
import 'package:drift/drift.dart';
import 'package:my_app_3/database/tables/scheduled_expense.dart';
import 'package:my_app_3/database/tables/tag.dart';

class ScheduledExpenseTag extends Table {
  IntColumn get tagId => integer().references(Tag, #id)();
  IntColumn get scheduledExpenseId => integer().references(ScheduledExpense, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {tagId,scheduledExpenseId};
}