
import 'package:floor/floor.dart';

class DateTimeTc extends TypeConverter<DateTime, String> {
  @override
  DateTime decode(String databaseValue) {
    return DateTime.parse(databaseValue);
  }

  @override
  String encode(DateTime value) {
    return value.toIso8601String();
  }
}