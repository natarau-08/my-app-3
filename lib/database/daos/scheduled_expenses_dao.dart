
import 'package:drift/drift.dart';

import '../../pages/expense_list_page.dart';
import '../../utils.dart';
import '../database.dart';
import '../tables/expense.dart';
import '../tables/scheduled_expense.dart';
import '../tables/scheduled_expense_tag.dart';
import '../tables/tag.dart';

part 'scheduled_expenses_dao.g.dart';

@DriftAccessor(
    tables: [
      ScheduledExpense,
      ScheduledExpenseTag,
      Tag,
      Expense
    ]
)
class ScheduledExpenseDao extends DatabaseAccessor<AppDatabase> with _$ScheduledExpenseDaoMixin {
  ScheduledExpenseDao(super.attachedDatabase);

  Future<int> saveScheduledExpense(Insertable<ScheduledExpenseData> e) => into(scheduledExpense).insertOnConflictUpdate(e);
  Future<(int, int)> deleteScheduledExpense(int id) async {
    final t = await (
        delete(scheduledExpenseTag)
          ..where((x) => x.scheduledExpenseId.equals(id))
    ).go();

    final s = await (
        delete(scheduledExpense)
          ..where((x) => x.id.equals(id))
    ).go();

    return (t, s);
  }

  Future<void> setTags(List<TagData> tags, int eid) async {
    await (delete(scheduledExpenseTag)..where((x) => x.scheduledExpenseId.equals(eid))).go();
    final comps = tags.map((x) => ScheduledExpenseTagCompanion(
        scheduledExpenseId: Value(eid),
        tagId: Value(x.id)
    ));

    await batch((b){
      b.insertAll(scheduledExpenseTag, comps);
    });
  }

  Future<void> insertTag(int scheduledExpenseId, int tagId) async {
    await into(scheduledExpenseTag).insert(ScheduledExpenseTagCompanion(
      scheduledExpenseId: Value(scheduledExpenseId),
      tagId: Value(tagId)
    ));
  }

  Future<void> saveExpenseFromScheduled(ScheduledExpenseData sch, DateTime date) async {
    // save expense
    int eid = await AppDatabase.expensesDao.saveExpense(ExpenseCompanion(
        createdDate: Value(date),
        details: sch.details == null ? const Value.absent() : Value(sch.details),
        generated: Value(sch.id),
        id: const Value.absent(),
        value: Value(sch.value)
    ));

    // save tags
    final tags = await (
        select(tag)
          ..join([
            innerJoin(
                scheduledExpenseTag,
                tag.id.equalsExp(scheduledExpenseTag.tagId) & scheduledExpenseTag.scheduledExpenseId.equals(sch.id),
                useColumns: false
            )
          ])
    ).get();

    await AppDatabase.expensesDao.setTags(tags, eid);
  }

  Future<void> generateExpenses() async {
    final now = DateTime.now();
    final dataList = await (select(scheduledExpense)..where((x) => x.nextInsert.isSmallerOrEqualValue(now))).get();

    int c = 0;
    for(var data in dataList){
      DateTime next = data.nextInsert;

      if(data.repeatDaily){
        next = next.add(const Duration(hours: 24));

        while(next.isBefore(now)){
          await saveExpenseFromScheduled(data, next);
          next = next.add(const Duration(hours: 24));
          c++;
        }

      }else if(data.repeatWeekly){
        next = next.add(const Duration(days: 7));

        while(next.isBefore(now)){
          await saveExpenseFromScheduled(data, next);
          next = next.add(const Duration(days: 7));
          c++;
        }

      }else if(data.repeatMonthly){
        next = Utils.addMonths(next, 1);
        while(next.isBefore(now)){
          await saveExpenseFromScheduled(data, next);
          next = Utils.addMonths(next, 1);
          c++;
        }
      }else if(data.repeatYearly){
        next = Utils.addMonths(next, 12);
        while(next.isBefore(now)){
          await saveExpenseFromScheduled(data, next);
          next = Utils.addMonths(next, 12);
          c++;
        }
      }

      final comp = data.copyWith(nextInsert: next).toCompanion(true);
      await saveScheduledExpense(comp);
    }

    if(c > 0){
      Utils.infoMessage('Scheduled expenses: Generated $c expenses.');
      ExpenseListPage.onExpensesChangedCallback?.call();
    }
  }

  Future<int> getAllScheduledExpenseCount() => scheduledExpense.count().getSingle();
  Future<int> getAllScheduledExpenseTagCount() => scheduledExpenseTag.count().getSingle();

  Future<List<ScheduledExpenseData>> getScheduledExpenseBatch(int batchSize, int lastId) async {
    final q = select(scheduledExpense)
      ..where((x) => x.id.isBiggerThanValue(lastId))
      ..orderBy([
            (u) => OrderingTerm(expression: u.id, mode: OrderingMode.asc)
      ])
      ..limit(batchSize);

    return await q.get();
  }

  Future<(List<ScheduledExpenseTagData>, int)> getScheduledExpenseTagBatch(int batchSize, int lastId) async {
    final qe = select(scheduledExpense)
      ..where((x) => x.id.isBiggerThanValue(lastId))
      ..orderBy([
            (u) => OrderingTerm(expression: u.id, mode: OrderingMode.asc)
      ])
      ..limit(batchSize);

    final subquery = Subquery(qe, 'se');

    final newLastId = (await (
        select(subquery)
          ..orderBy([
                (u) => OrderingTerm(expression: u.ref(scheduledExpense.id), mode: OrderingMode.desc)
          ])
          ..limit(1)
    ).getSingleOrNull())?.id ?? lastId;

    final q = select(scheduledExpenseTag).join([
      innerJoin(subquery, subquery.ref(scheduledExpense.id).equalsExp(scheduledExpenseTag.scheduledExpenseId), useColumns: false)
    ]);

    final data = await q.map((x) => x.readTable(scheduledExpenseTag)).get();

    return (data , newLastId);
  }

  Stream<List<ScheduledExpenseData>> watchScheduledExpenses() {
    final q = select(scheduledExpense)
        ..orderBy([
      (u) => OrderingTerm(expression: u.id, mode: OrderingMode.asc)
    ]);

    return q.watch();
  }
}