
import 'package:floor/floor.dart';
import 'package:my_app_3/floor/tables/tag.dart';

@dao
abstract class TagDao {
  @Query('select * from tags')
  Stream<List<Tag>> watchAllTags();

  @Query('select * from tags')
  Future<List<Tag>> getAllTags();

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

  @Query('select count(*) from tags')
  Future<int?> getAllTagsCount();

  @Query('''select * from tags t
  where t.id > :lastId
  order by t.id
  limit :batchSize''')
  Future<List<Tag>> getBatch(int batchSize, int lastId);

  @Query('select id from tags where name = :name')
  Future<int?> getTagIdByName(String name);
}