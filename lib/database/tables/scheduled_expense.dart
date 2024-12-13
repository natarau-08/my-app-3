
import 'package:drift/drift.dart';

class ScheduledExpense extends Table {
  IntColumn get id => integer()();
  RealColumn get value => real()();
  TextColumn get details => text()();
  DateTimeColumn get createdDate => dateTime()();

  DateTimeColumn get nextInsert => dateTime()();

  BoolColumn get repeatDaily => boolean()();
  BoolColumn get repeatWeekly => boolean()();
  BoolColumn get repeatMonthly => boolean()();
  BoolColumn get repeatYearly => boolean()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}