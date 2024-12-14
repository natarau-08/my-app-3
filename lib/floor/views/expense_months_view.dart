
import 'package:floor/floor.dart';

@DatabaseView(
  '''select distinct
  strftime('%Y', e.created_date) as year,
  strftime('%M', e.created_date) as month
from expenses e
order by year, month''',
  viewName: 'vw_expense_months_view'
)
class ExpenseMonthsView {
  @ColumnInfo()
  final int year;

  @ColumnInfo()
  final int month;

  ExpenseMonthsView(this.year, this.month);
}