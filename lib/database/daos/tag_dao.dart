
import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/expense_tag.dart';
import '../tables/tag.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [Tag, ExpenseTag])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  SimpleSelectStatement<$TagTable, TagData> _queryAll() {
    final query = select(tag)..orderBy([
          (t) => OrderingTerm(expression: t.added, mode: OrderingMode.asc)
    ]);
    return query;
  }

  Stream<List<TagData>> watchAllTags(bool deleted) => (
      _queryAll()..where((x) => x.deleted.equals(deleted))
  ).watch();

  Future<List<TagData>> getAllTags() => (_queryAll()..where((x) => x.deleted.equals(false))).get();

  Future<int> insertTag(Insertable<TagData> e) => into(tag).insert(e);
  Future<int> deleteTagById(int id) => (delete(tag)..where((t) => t.id.equals(id))).go();
  Future<bool> updateTag(Insertable<TagData> e) => update(tag).replace(e);

  Future<int> updateTagById(int id, TagCompanion comp) => (update(tag)..where((x) => x.id.equals(id))).write(comp);

  Future<int> getTagExpenseCount(int id) async {
    final exp = expenseTag.expenseId.count();
    final query = selectOnly(expenseTag)
      ..addColumns([exp])
      ..where(expenseTag.tagId.equals(id));

    return await query.map((x) => x.read(exp)).getSingle() ?? 0;
  }

  Future<int> getAllTagsCount() async {
    final exp = tag.id.count();
    final q = selectOnly(tag)..addColumns([exp]);
    return await q.map((x) => x.read(exp)).getSingle() ?? 0;
  }

  Future<List<TagData>> getBatch(int batchSize, int lastId) async {
    final q = select(tag)
      ..where((t) => t.id.isBiggerThanValue(lastId))
      ..orderBy([
            (u) => OrderingTerm(expression: u.id, mode: OrderingMode.asc)
      ])
      ..limit(batchSize);

    return await q.get();
  }
}