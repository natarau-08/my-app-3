
import 'package:drift/drift.dart';

import '../tables/expense.dart';


abstract class ExpenseMonthSummaryView extends View {
  Expense get expenses;

  Expression<double> get totalMonth => expenses.value.sum();
  Expression<double> get totalMonthGain => expenses.value.sum(filter: expenses.value.isSmallerThanValue(0));
  Expression<double> get totalMonthLoss => expenses.value.sum(filter: expenses.value.isBiggerThanValue(0));

  Expression<int> get year => expenses.createdDate.year;
  Expression<int> get month => expenses.createdDate.month;

  @override
  Query as() => select([
    year,
    month,
    totalMonth,
    totalMonthGain,
    totalMonthLoss
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