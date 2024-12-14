
import 'package:floor/floor.dart';

@Entity(
  tableName: 'expense_tags',
  indices: [
    Index(value: ['tag_id']),
    Index(value: ['expense_id']),
  ],
  primaryKeys: ['tag_id', 'expense_id']
)
class ExpenseTag {
  @ColumnInfo(name: 'tag_id')
  int? tagId;

  @ColumnInfo(name: 'expense_id')
  int? expenseId;

  ExpenseTag({
    this.tagId,
    this.expenseId
  });
}