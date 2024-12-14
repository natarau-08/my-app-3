
import 'package:floor/floor.dart';

@Entity(
  tableName: 'scheduled_expense_tags',
  primaryKeys: ['tag_id', 'scheduled_expense_id'],
  indices: [
    Index(value: ['tag_id']),
    Index(value: ['scheduled_expense_id']),
  ]
)
class ScheduledExpenseTag {
  @ColumnInfo(name: 'tag_id')
  int? tagId;

  @ColumnInfo(name: 'scheduled_expense_id')
  int? scheduledExpenseId;

  ScheduledExpenseTag({
    this.tagId,
    this.scheduledExpenseId
  });
}