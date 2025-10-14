
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/car_revision.dart';
import 'package:my_app_3/floor/tables/car_revision_type.dart';
import 'package:my_app_3/utils.dart';
import 'package:rxdart/rxdart.dart';

class RevisionModel {
  final CarRevisionType type;
  final CarRevision revision;

  String get mame => type.name;
  String get date => Utils.formatDateTimeLong(revision.date);

  RevisionModel({
    required this.type,
    required this.revision,
  });

  static Stream<List<RevisionModel>> streamByCarId(int carId){
    final dao = AppDatabase.instance.carRevisionDao;
    final typesStream = dao.streamTypesByCarId(carId);
    final revsStream = dao.streamByCarId(carId);

    return Rx.combineLatest2(typesStream, revsStream, (types, revisions){
      return revisions.map((rev){
        final type = types.firstWhere((t) => t.id == rev.revisionTypeId);
        return RevisionModel(type: type, revision: rev);
      }).toList();
    });
  }
}