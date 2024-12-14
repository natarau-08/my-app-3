import 'package:floor/floor.dart';

@Entity(
  tableName: 'app_settings',
)
class AppSettings {
  @PrimaryKey(autoGenerate: true)
  int? key;

  @ColumnInfo(name: 'value')
  String? value;

  AppSettings({
    this.key,
    this.value
  });
}