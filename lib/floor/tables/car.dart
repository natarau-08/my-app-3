
import 'package:floor/floor.dart';

@Entity(
  tableName: 'cars',
  indices: [
    Index(value: ['id']),
  ],
  primaryKeys: ['id']
)
class Car {
  @ColumnInfo(name: 'id')
  int? id;

  @ColumnInfo(name: 'brand')
  String brand;

  @ColumnInfo(name: 'model')
  String model;

  @ColumnInfo(name: 'year')
  int year;

  @ColumnInfo(name: 'odometer')
  int odometer;

  Car({
    this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.odometer,
  });

  Car.empty(): id = null, brand = '', model = '', year = 0, odometer = 0;
}