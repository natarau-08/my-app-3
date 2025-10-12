

import 'package:floor/floor.dart';
import 'package:my_app_3/floor/tables/car.dart';

@Entity(
  tableName: 'car_repairs',
  indices: [
    Index(value: ['id']),
    Index(value: ['car_id']),
  ],
  primaryKeys: ['id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['car_id'],
      parentColumns: ['id'],
      entity: Car,
      onDelete: ForeignKeyAction.cascade,
    ),
  ]
)
class CarRepair {
  @ColumnInfo(name: 'id')
  int? id;

  @ColumnInfo(name: 'car_id')
  int? carId;

  @ColumnInfo(name: 'date')
  DateTime? date;

  @ColumnInfo(name: 'description')
  String? description;

  @ColumnInfo(name: 'cost')
  double? cost;

  CarRepair({
    this.id,
    this.carId,
    this.date,
    this.description,
    this.cost,
  });
}