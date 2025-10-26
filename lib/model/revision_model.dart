
import 'package:flutter/material.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/floor/tables/car_revision.dart';
import 'package:my_app_3/floor/tables/car_revision_type.dart';
import 'package:my_app_3/utils.dart';
import 'package:rxdart/rxdart.dart';

class RevisionModel {
  final CarRevisionType type;
  final CarRevision revision;
  final Car car;

  late final DateTime? _nextDate;
  late final int? _nextOdo;

  String get mame => type.name;
  String get date => Utils.formatDateTimeLong(revision.date);
  String get odometer => Utils.formatBigInt(revision.odometer)!;
  String? get nextDate => Utils.formatDateTimeLongN(_nextDate);
  String? get nextOdometer => Utils.formatBigInt(_nextOdo);
  String? get notes => revision.notes;

  late final String? warningMessage;
  late final IconData? warningIcon;

  RevisionModel({
    required this.type,
    required this.revision,
    required this.car,
  }){
    _nextDate = type.intervalMonths != null ? Utils.addMonths(revision.date, type.intervalMonths!) : null;
    _nextOdo = type.intervalKm != null ? revision.odometer + type.intervalKm! : null;
    // date test
    final now = DateTime.now();
    if(_nextDate != null){
      if(now.isAfter(_nextDate)){
          warningMessage = '${type.name} missed!';
          warningIcon = Icons.dangerous;
          return;
      } else if(_nextDate.difference(now).inDays <= 30){
          warningMessage = '${type.name} in 30 days.';
          warningIcon = Icons.warning;
          return;
      }
    }

    if(_nextOdo != null){
      if(car.odometer >= _nextOdo){
          warningMessage = '${type.name} missed!';
          warningIcon = Icons.dangerous;
          return;
      } 
      
      final r = _nextOdo - car.odometer;
      if(r <= 1000){
          warningMessage = '${type.name} in $r km.';
          warningIcon = Icons.warning;
          return;
      }
    }

    warningMessage = null;
    warningIcon = null;
  }

  // Fetch revisions by car id
  static Future<List<RevisionModel>> fetchByCarId(int carId) async {
    final dao = AppDatabase.instance.carRevisionDao;
    final types = await dao.getTypesByCarId(carId);
    final revisions = await dao.getByCarId(carId);
    final car = await AppDatabase.instance.carDao.findById(carId) as Car;

    return revisions.map((rev){
      final type = types.firstWhere((t) => t.id == rev.revisionTypeId);
      return RevisionModel(type: type, revision: rev, car: car);
    }).toList();
  }

  static Stream<List<RevisionModel>> streamByCarId(int carId) {
    final dao = AppDatabase.instance.carRevisionDao;
    final carStream = AppDatabase.instance.carDao.streamById(carId);
    final revisionsStream = dao.streamByCarId(carId);
    final typesStream = dao.streamTypesByCarId(carId);

    return Rx.combineLatest3(
      carStream,
      revisionsStream,
      typesStream,
      (Car? car, List<CarRevision> revisions, List<CarRevisionType> types){
        if(car == null) return List.empty();

        return revisions.map((rev){
          final type = types.firstWhere((t) => t.id == rev.revisionTypeId);
          return RevisionModel(type: type, revision: rev, car: car);
        }).toList();
      }
    );
  }
}