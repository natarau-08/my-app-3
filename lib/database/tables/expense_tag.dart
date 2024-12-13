
import 'package:drift/drift.dart';
import 'package:my_app_3/database/tables/tag.dart';

import 'expense.dart';

@TableIndex(name: 'idx_tag_id', columns: {#tagId})
@TableIndex(name: 'idx_expense_id', columns: {#expenseId})
class ExpenseTag extends Table {
  IntColumn get tagId => integer().references(Tag, #id)();
  IntColumn get expenseId => integer().references(Expense, #id)();

  @override
  Set<Column> get primaryKey => {tagId, expenseId};
}