
import 'package:floor/floor.dart';

@DatabaseView(
  '''
select
  e.id,
  e.created_date,
  e.value,
  e.details,
  e.generated,

  count(et.tag_id) as total_tags,
  min(t.name) as first_tag,

  CAST(strftime('%Y', created_date) as INTEGER) as year,
  CAST(strftime('%m', created_date) as INTEGER) as month
from expenses e
left join expense_tags et on et.expense_id = e.id
left join tags t on t.id = et.tag_id
group by e.id, e.created_date, e.value, e.details, e.generated
order by e.created_date
''',
  viewName: 'vw_expense_list',
)
class ExpenseListView {
  @ColumnInfo(name: 'id')
  final int id;

  @ColumnInfo(name: 'created_date')
  final DateTime createdDate;

  @ColumnInfo(name: 'value')
  final double value;

  @ColumnInfo(name: 'details')
  final String? details;

  @ColumnInfo(name: 'generated')
  final int? generated;

  @ColumnInfo(name: 'first_tag')
  final String? firstTag;

  @ColumnInfo(name: 'total_tags')
  final int totalTags;

  @ColumnInfo(name: 'year')
  final int year;

  @ColumnInfo(name: 'month')
  final int month;

  ExpenseListView({
    required this.id,
    required this.createdDate,
    required this.value,
    required this.details,
    required this.generated,
    required this.firstTag,
    required this.totalTags,
    required this.year,
    required this.month,
  });
}