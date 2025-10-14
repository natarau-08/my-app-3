
import 'package:floor/floor.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/floor/tables/car_revision_type.dart';

@Entity(
  tableName: 'car_revisions',
  indices: [
    Index(value: ['id']),
    Index(value: ['car_id']),
    Index(value: ['revision_type_id'])
  ],
  primaryKeys: ['id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['car_id'],
      parentColumns: ['id'],
      entity: Car,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['revision_type_id'],
      parentColumns: ['id'],
      entity: CarRevisionType,
      onDelete: ForeignKeyAction.noAction,
    ),
  ]
)
class CarRevision {
  @ColumnInfo(name: 'id')
  int? id;

  @ColumnInfo(name: 'car_id')
  int carId = 0;

  @ColumnInfo(name: 'revision_type_id')
  int revisionTypeId = 0;

  @ColumnInfo(name: 'date')
  DateTime date;

  @ColumnInfo(name: 'odometer')
  int odometer = 0;

  @ColumnInfo(name: 'notes')
  String? notes;

  CarRevision({
    this.id,
    required this.carId,
    required this.revisionTypeId,
    required this.date,
    required this.odometer,
    this.notes,
  });

  CarRevision.create(this.carId):
    date = DateTime.now();
}