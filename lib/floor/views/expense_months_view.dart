
import 'package:floor/floor.dart';

@DatabaseView(
  '''select distinct
  CAST(strftime('%Y', e.created_date) as INTEGER) as year,
  CAST(strftime('%m', e.created_date) as INTEGER) as month
from expenses e
order by year, month''',
  viewName: 'vw_expense_months'
)
class ExpenseMonthsView {
  @ColumnInfo()
  final int year;

  @ColumnInfo()
  final int month;

  ExpenseMonthsView(this.year, this.month);
}