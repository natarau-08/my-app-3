
import 'package:floor/floor.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/expense.dart';
import 'package:my_app_3/floor/tables/scheduled_expense.dart';
import 'package:my_app_3/floor/tables/scheduled_expense_tag.dart';
import 'package:my_app_3/floor/tables/tag.dart';

import '../../pages/expense_list_page.dart';
import '../../utils.dart';

@dao
abstract class ScheduledExpenseDao {
  @Insert()
  Future<int> insert(ScheduledExpense e);

  @Update()
  Future<void> update(ScheduledExpense e);

  Future<int> saveScheduledExpense(ScheduledExpense e) async {
    if(e.id == null){
      return await insert(e);
    }else{
      await update(e);
      return e.id!;
    }
  }

  Future<void> setTags(List<Tag> tags, int eid) async {
    await deleteTagsById(eid);
    
    final scht = tags
      .map((t)=>ScheduledExpenseTag(
        tagId: t.id!,
        scheduledExpenseId: eid
      ))
      .toList();

    await insertTags(scht);
  }

  Future<void> insertTag(int scheduledExpenseId, int tagId) => insertTagEntity(ScheduledExpenseTag(
    scheduledExpenseId: scheduledExpenseId,
    tagId: tagId
  ));

  // creates an expense from a scheduled expense
  Future<void> saveExpenseFromScheduled(ScheduledExpense sch, DateTime date) async {
    // save expense
    int eid = await AppDatabase.instance.expenseDao.insert(Expense(
      createdDate: date,
      details: sch.details,
      generated: sch.id,
      value: sch.value
    ));

    // save tags
    final tags = await getTagsOfScheduledExpense(sch.id!);
    await AppDatabase.instance.expenseDao.setTags(tags, eid);
  }

  Future<void> generateExpenses() async {
    final now = DateTime.now();
    final list = await getScheduledExpensesWithNextInsertSmallerThan(now);

    int c = 0;
    for(var data in list){
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

      data.nextInsert = next;
      await saveScheduledExpense(data);
    }

    if(c > 0){
      Utils.infoMessage('Scheduled expenses: Generated $c expenses.');
      ExpenseListPage.onExpensesChangedCallback?.call();
    }
  }

  @Query('select count(*) from scheduled_expenses')
  Future<int?> getAllScheduledExpenseCount();

  @Query('select count(*) from scheduled_expense_tags')
  Future<int?> getAllScheduledExpenseTagCount();

  @Query('select * from scheduled_expenses where id>:lastId order by id limit :batchSize')
  Future<List<ScheduledExpense>> getScheduledExpenseBatch(int batchSize, int lastId);

  Future<(List<ScheduledExpenseTag>, int)> getScheduledExpenseTagBatch(int batchSize, int lastId) async {
    final qe = await getScheduledExpenseBatch(batchSize, lastId);
    final newLastId = qe.lastOrNull?.id ?? lastId;

    final data = <ScheduledExpenseTag>[];
    for(final e in qe){
      data.addAll(await getScheduledExpenseTagsById(e.id!));
    }

    return (data , newLastId);
  }

  @Query('select * from scheduled_expenses order by id')
  Stream<List<ScheduledExpense>> watchScheduledExpenses();

  @Query('select * from scheduled_expense_tags where scheduled_expense_id=:id')
  Future<List<ScheduledExpenseTag>> getScheduledExpenseTagsById(int id);

  @Query('select * from scheduled_expenses where next_insert <= :t')
  Future<List<ScheduledExpense>> getScheduledExpensesWithNextInsertSmallerThan(DateTime t);

  @Query('select t.* from scheduled_expense_tags st join tags t on t.id = st.tag_id where st.scheduled_expense_id=:id')
  Future<List<Tag>> getTagsOfScheduledExpense(int id);

  @Query('delete from scheduled_expense_tag where scheduled_expense_id=:id')
  Future<void> deleteTagsById(int id);

  @Insert()
  Future<void> insertTags(List<ScheduledExpenseTag> tags);

  @Insert()
  Future<void> insertTagEntity(ScheduledExpenseTag t);
}