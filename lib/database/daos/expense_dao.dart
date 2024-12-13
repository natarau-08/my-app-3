
import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/expense.dart';
import '../tables/expense_tag.dart';
import '../tables/tag.dart';
import '../views/expense_list_view.dart';
import '../views/expense_month_summary_view.dart';
import '../views/expense_months_view.dart';

part 'expense_dao.g.dart';

@DriftAccessor(
  tables: [Expense, Tag, ExpenseTag],
  views: [
    ExpenseListView,
    ExpenseMonthSummaryView,
    ExpenseMonthsView,
  ],
)
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  Future<List<TagData>> getTagsForExpenseId(int eid) async {
    final query = select(tag).join([
      innerJoin(expenseTag, tag.id.equalsExp(expenseTag.tagId), useColumns: false)
    ])
      ..where(expenseTag.expenseId.equals(eid));

    return query.map((row) => row.readTable(tag)).get();
  }

  Future<void> setTags(List<TagData> tags, int eid) async {
    final tagsCopy = List<TagData>.from(tags);
    final dbTags = await getTagsForExpenseId(eid);

    // delete tags in database if they do not exist in the copy list
    // remove from copyList if they exist in database
    while(dbTags.isNotEmpty){
      final dbt = dbTags.removeAt(0);
      if(tagsCopy.contains(dbt)){
        tagsCopy.remove(dbt);
      }else{
        await deleteExpenseTagByIds(eid, dbt.id);
      }
    }

    // insert from copy list into database
    if(tagsCopy.isNotEmpty){
      final insertable = tagsCopy.map((x) => ExpenseTagCompanion(
          expenseId: Value(eid),
          tagId: Value(x.id)
      ));
      await batch((b){
        b.insertAll(expenseTag, insertable);
      });
    }
  }

  Future<List<ExpenseListViewData>> getExpenseListViewData() async {
    var lastDate = await (
        select(expense)..orderBy([
              (et) => OrderingTerm(expression: et.createdDate, mode: OrderingMode.desc)
        ])
          ..limit(1)
    )
        .map((x) => x.createdDate)
        .getSingleOrNull();

    if(lastDate == null) return List<ExpenseListViewData>.empty();

    final startDate = lastDate.add(const Duration(days: -90));

    var query = select(expenseListView)
      ..where((e) => e.createdDate.isBiggerOrEqualValue(startDate))
      ..orderBy([
            (e) => OrderingTerm(expression: e.createdDate, mode: OrderingMode.asc)
      ]);

    return await query.get();
  }

  Future<int> saveExpense(Insertable<ExpenseData> e) => into(expense).insertOnConflictUpdate(e);
  Future<int> deleteExpenseById(int id) => (delete(expense)..where((e) => e.id.equals(id))).go();

  Future<int> deleteExpenseTagByIds(int eid, int tid) => (delete(expenseTag)..where((et) => et.expenseId.equals(eid) & et.tagId.equals(tid))).go();

  // why would you do this?
  Future<void> batchInsertExpenses(Iterable<Insertable<ExpenseData>> rows) => batch((b) => b.insertAll(expense, rows));
  Future<void> batchInsertTags(Iterable<Insertable<TagData>> rows) => batch((b) => b.insertAll(tag, rows));
  Future<void> batchInsertExpenseTags(Iterable<Insertable<ExpenseTagData>> rows) => batch((b) => b.insertAll(expenseTag, rows));

  Future<int> insertExpenseTag(Insertable<ExpenseTagData> e) => into(expenseTag).insert(e);

  //
  Stream<List<dynamic>> streamExpensesAndSummaries(int months) async* {

    // we should have the last three distinct pairs of (year, month) in desc order
    final ympairs = await (select(expenseMonthsView)..limit(months)).get();

    for(var ym in ympairs.reversed){
      // fetch and yeild expenses
      final expenses = await (select(expenseListView)
        ..where((e) => e.createdDate.month.equals(ym.month!) & e.createdDate.year.equals(ym.year!))
        ..orderBy([
              (e) => OrderingTerm(expression: e.createdDate)
        ])
      ).get();

      yield expenses;

      // yield summary, should only be one entry
      final summary = await (select(expenseMonthSummaryView)
        ..where((s) => s.year.equals(ym.year!) & s.month.equals(ym.month!))
      ).get();

      assert (summary.length == 1, 'Month summary view returned ${summary.length} rows instead of 1');

      yield summary;
    }
  }

  Future<ExpenseData> findExpenseById(int id) => (select(expense)..where((e) => e.id.equals(id))).getSingle();

  Future<ExpenseListViewData> getViewDataForExpenseId(int id) => (select(expenseListView)..where((e) => e.id.equals(id))).getSingle();

  Future<int> getExpenseCount() async {
    final expr = expense.id.count();
    final q = selectOnly(expense)..addColumns([expr]);
    return await q.map((x) => x.read(expr)).getSingle() ?? 0;
  }

  Future<int> getAllExpenseTagCount() => expenseTag.count().getSingle();

  Future<List<ExpenseData>> getExpenseBatch(int batchSize, int lastId) async {
    final q = select(expense)
      ..where((x) => x.id.isBiggerThanValue(lastId))
      ..orderBy([
            (u) => OrderingTerm(expression: u.id, mode: OrderingMode.asc)
      ])
      ..limit(batchSize);

    return await q.get();
  }

  Future<(List<ExpenseTagData> data, int lastId)> getExpenseTagBatch(int batchSize, int lastId) async {
    final qe = select(expense)
      ..where((x) => x.id.isBiggerThanValue(lastId))
      ..orderBy([
            (u) => OrderingTerm(expression: u.id, mode: OrderingMode.asc)
      ])
      ..limit(batchSize);

    final subq = Subquery(qe, 'e');

    final newLastId = (await (
        select(subq)
          ..orderBy([
                (u) => OrderingTerm(expression: u.ref(expense.id), mode: OrderingMode.desc)
          ])
          ..limit(1)
    ).getSingleOrNull())?.id ?? lastId;

    final q = select(expenseTag)
        .join([
      innerJoin(subq, subq.ref(expense.id).equalsExp(expenseTag.expenseId), useColumns: false)
    ]);

    final data = await q.map((x) => x.readTable(expenseTag)).get();

    return (data , newLastId);
  }
}