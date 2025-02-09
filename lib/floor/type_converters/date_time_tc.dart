
import 'package:floor/floor.dart';

class DateTimeTc extends TypeConverter<DateTime?, String?> {
  @override
  DateTime? decode(String? databaseValue) {
    if (databaseValue == null) {
      return null;
    }
    return DateTime.parse(databaseValue);
  }

  @override
  String? encode(DateTime? value) {
    if(value == null) return null;
    return value.toIso8601String();
  }
}

class DateTimeTc2 extends TypeConverter<DateTime, String> {
  @override
  DateTime decode(String databaseValue) {
    return DateTime.parse(databaseValue);
  }

  @override
  String encode(DateTime value) {
    return value.toIso8601String();
  }
}
