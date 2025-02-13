
import 'package:floor/floor.dart';

import '../tables/tag_tracking.dart';

@dao
abstract class TagTrackingDao {  
  @Insert()
  Future<int> insert(TagTracking e);

  @Update()
  Future<void> update(TagTracking e);

  @delete
  Future<void> deleteTagTracking(TagTracking e);

  @Query('select * from tag_tracking order by id')
  Stream<List<TagTracking>> streamAllTagTrackings();
}