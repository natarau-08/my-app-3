
import 'package:floor/floor.dart';

@Entity(
  tableName: 'expenses',
)
class Expense {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'value')
  double value;

  @ColumnInfo(name: 'details')
  String? details;

  @ColumnInfo(name: 'created_date')
  DateTime createdDate;

  @ColumnInfo(name: 'generated')
  int? generated;

  Expense({
    this.id,
    this.value = 0,
    this.details,
    required this.createdDate,
    this.generated
  });
}