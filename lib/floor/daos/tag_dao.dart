
import 'package:floor/floor.dart';
import 'package:my_app_3/floor/tables/tag.dart';

@dao
abstract class TagDao {
  @Query('select * from tags where deleted=0')
  Stream<List<Tag>> streamActiveTags();

  @Query('select * from tags where deleted=1')
  Stream<List<Tag>> streamDeletedTags();

  @Query('select * from tags where deleted=0 order by last_used desc, name')
  Future<List<Tag>> getActiveTags();

  @Insert()
  Future<int> insertTag(Tag e);

  @Insert()
  Future<void> insertList(List<Tag> tags);

  @Query('delete from tags where id=:id')
  Future<void> deleteTagById(int id);

  @Update()
  Future<void> update(Tag t);

  @Query('''select COUNT(e.id)
  from expense_tags et
  join expenses e on e.id = et.expense_id
  where et.tag_id = :id''')
  Future<int?> getTagExpenseCount(int id);

  @Query('select id from tags where name = :name')
  Future<int?> getTagIdByName(String name);

  @Query('select * from tags where id = :id')
  Future<Tag?> findById(int id);
}