
import 'package:drift/drift.dart';

class AppSetting extends Table {
  IntColumn get key => integer()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}