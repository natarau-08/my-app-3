
import 'package:floor/floor.dart';

@Entity(
  tableName: 'scheduled_expenses',
)
class ScheduledExpense {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'value')
  double value;

  @ColumnInfo(name: 'details')
  String? details;

  @ColumnInfo(name: 'created_date')
  DateTime createdDate;

  @ColumnInfo(name: 'next_insert')
  DateTime nextInsert;

  @ColumnInfo(name: 'repeat_pattern')
  String repeatPattern;

  ScheduledExpense({
    this.id,
    this.value = 0,
    this.details,
    required this.createdDate,
    required this.nextInsert,
    required this.repeatPattern
  });

  // legacy
  bool get repeatDaily => repeatPattern.contains('D');
  bool get repeatWeekly => repeatPattern.contains('w');
  bool get repeatMonthly => repeatPattern.contains('M');
  bool get repeatYearly => repeatPattern.contains('Y');

  void setRepeatPattern({bool? daily, bool? weekly, bool? monthly, bool? yearly}){
    daily ??= repeatDaily;
    weekly ??= repeatWeekly;
    monthly ??= repeatMonthly;
    yearly ??= repeatYearly;
    repeatPattern = buildRepeatPattern(daily, weekly, monthly, yearly);
  }

  static String buildRepeatPattern(bool daily, bool weekly, bool monthly, bool yearly){
    final sb = StringBuffer();
    if(daily){
      sb.write('D');
    }
    if(weekly){
      sb.write('w');
    }
    if(monthly){
      sb.write('M');
    }
    if(yearly){
      sb.write('Y');
    }
    return sb.toString();
  }
}