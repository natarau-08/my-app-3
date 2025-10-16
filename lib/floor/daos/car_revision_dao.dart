import 'package:floor/floor.dart';
import 'package:my_app_3/floor/tables/car_revision.dart';
import 'package:my_app_3/floor/tables/car_revision_type.dart';

@dao
abstract class CarRevisionDao {
  @Query('SELECT * FROM car_revision_types WHERE car_id = :carId')
  Stream<List<CarRevisionType>> streamTypesByCarId(int carId);

  @Query('select * from car_revisions where car_id = :carId')
  Stream<List<CarRevision>> streamByCarId(int carId);

  @insert
  Future<int> insertType(CarRevisionType type);

  @update
  Future<int> updateType(CarRevisionType type);

  @delete
  Future<int> deleteType(CarRevisionType type);

  @insert
  Future<int> insertRevision(CarRevision revision);

  @update
  Future<int> updateRevision(CarRevision revision);

  @delete
  Future<int> deleteRevision(CarRevision revision);
}