
import 'package:drift/drift.dart';

class Tag extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get description => text().nullable()();
  IntColumn get color => integer().nullable()();
  DateTimeColumn get added => dateTime()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
}
