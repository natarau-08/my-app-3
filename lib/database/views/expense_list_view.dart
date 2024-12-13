
import 'package:drift/drift.dart';

import '../tables/expense.dart';
import '../tables/expense_tag.dart';
import '../tables/tag.dart';

abstract class ExpenseListView extends View {
  Expense get expenses;
  Tag get tags;
  ExpenseTag get expenseTags;

  Expression<int> get totalTags => tags.id.count();
  Expression<String> get firstTag => tags.name.min();

  @override
  Query as() => select([
    expenses.id,
    expenses.createdDate,
    expenses.value,
    expenses.details,
    expenses.generated,

    totalTags,
    firstTag
  ])
      .from(expenses)
      .join([
    leftOuterJoin(expenseTags, expenseTags.expenseId.equalsExp(expenses.id), useColumns: false),
    leftOuterJoin(tags, tags.id.equalsExp(expenseTags.tagId), useColumns: false)
  ])
    ..groupBy([
      expenses.id,
      expenses.createdDate,
      expenses.value,
      expenses.details,
      expenses.generated,
    ])
    ..orderBy([
      OrderingTerm(expression: expenses.createdDate, mode: OrderingMode.asc)
    ]);
}