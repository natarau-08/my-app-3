import 'package:floor/floor.dart';
import 'package:my_app_3/floor/tables/car_revision_type.dart';

@dao
abstract class CarRevisionDao {
  @Query('SELECT * FROM car_revision_types WHERE car_id = :carId')
  Stream<List<CarRevisionType>> findRevisionTypesByCarId(int carId);

  @insert
  Future<int> insertType(CarRevisionType type);

  @update
  Future<int> updateType(CarRevisionType type);

  @delete
  Future<int> deleteType(CarRevisionType type);
}