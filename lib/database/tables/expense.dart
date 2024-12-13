
import 'package:drift/drift.dart';

class Expense extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get value => real()();
  TextColumn get details => text().nullable()();
  DateTimeColumn get createdDate => dateTime()();
  IntColumn get generated => integer().nullable()();
}