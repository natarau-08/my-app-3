
import 'package:floor/floor.dart';

@DatabaseView(
  '''
select
  ex.year,
  ex.month,
  CAST(SUM(ex.value) AS REAL) as total_month,
  CAST(SUM(case when ex.value > 0 then ex.value else 0 end) AS REAL) as total_month_gain,
  CAST(SUM(case when ex.value < 0 then ex.value else 0 end) AS REAL) as total_month_loss
from (
  select
    cast(strftime('%Y', e.created_date) as integer) as year,
    cast(strftime('%m', e.created_date) as integer) as month,
    e.value
  from expenses e
) ex
group by ex.year, ex.month
''',
  viewName: 'vw_expense_summary'
)
class ExpenseMonthSummaryView {
  @ColumnInfo(name: 'year')
  final int year;

  @ColumnInfo(name: 'month')
  final int month;

  @ColumnInfo(name: 'total_month')
  final double totalMonth;

  @ColumnInfo(name: 'total_month_loss')
  final double totalMonthLoss;

  @ColumnInfo(name: 'total_month_gain')
  final double totalMonthGain;

  ExpenseMonthSummaryView({
    required this.year,
    required this.month,
    required this.totalMonth,
    required this.totalMonthGain,
    required this.totalMonthLoss
  });
}