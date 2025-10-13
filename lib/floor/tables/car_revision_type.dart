
import 'package:floor/floor.dart';

@Entity(
  tableName: 'car_revision_types',
  indices: [
    Index(value: ['id']),
  ],
  primaryKeys: ['id']
)
class CarRevisionType {
  @ColumnInfo(name: 'id')
  int? id;

  @ColumnInfo(name: 'car_id')
  int carId;

  @ColumnInfo(name: 'name')
  String name;

  @ColumnInfo(name: 'interval_km')
  int? intervalKm;

  @ColumnInfo(name: 'interval_months')
  int? intervalMonths;

  CarRevisionType({
    this.id,
    required this.name,
    this.intervalKm,
    this.intervalMonths,
    required this.carId
  });
}