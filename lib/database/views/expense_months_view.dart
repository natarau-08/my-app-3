
import 'package:drift/drift.dart';

import '../tables/expense.dart';

abstract class ExpenseMonthsView extends View {
  Expense get expenses;

  Expression<int> get year => expenses.createdDate.year;
  Expression<int> get month => expenses.createdDate.month;

  @override
  Query as() => select([
    year,
    month
  ])
      .from(expenses)
      .join([])
    ..groupBy([
      year,
      month
    ])
    ..orderBy([
      OrderingTerm(expression: year, mode: OrderingMode.desc),
      OrderingTerm(expression: month, mode: OrderingMode.desc)
    ]);
}