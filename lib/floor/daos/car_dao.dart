
import 'package:floor/floor.dart';
import 'package:my_app_3/floor/tables/car.dart';

@dao
abstract class CarDao {
  @Query('SELECT * FROM cars')
  Stream<List<Car>> findAllCars();

  @insert
  Future<int> insertCar(Car car);

  @update
  Future<int> updateCar(Car car);

  @delete
  Future<int> deleteCar(Car car);
}