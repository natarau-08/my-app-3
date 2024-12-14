
import 'package:floor/floor.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/expense.dart';
import 'package:my_app_3/floor/tables/expense_tag.dart';
import 'package:my_app_3/floor/tables/tag.dart';
import 'package:my_app_3/floor/views/expense_list_view.dart';
import 'package:my_app_3/floor/views/expense_months_view.dart';

import '../type_converters/date_time_tc.dart';

@dao
abstract class ExpenseDao {

  @Query("""select
  t.*
from expense_tags et
join tags t on t.id = et.tag_id
where et.expense_id = :id""")
  Future<List<Tag>> getTagsForExpenseId(int id);

  @Query('delete from expense_tags where expense_id = :id')
  Future<void> deleteAllTagsForExpenseId(int id);

  Future<void> setTags(List<Tag> tags, int eid) async {
    await deleteAllTagsForExpenseId(eid);
    await AppDatabase.instance.tagDao.insertList(tags);
  }

  @Insert()
  Future<int> insert(Expense e);

  @Update()
  Future<void> update(Expense e);

  Future<int> saveExpense(Expense e) async {
    if(e.id != null){
      await update(e);
      return e.id!;
    }else{
      return await insert(e);
    }
  }

  // why would you do this? 
  @Insert()
  Future<void> batchInsertExpenses(List<Expense> rows);

  @Insert()
  Future<void> batchInsertTags(List<Tag> rows);

  @Insert()
  Future<void> batchInsertExpenseTags(List<ExpenseTag> rows);

  @Insert()
  Future<void> insertExpenseTag(ExpenseTag e);

  @Query('select * from vw_expense_months limit :limit')
  Future<List<ExpenseMonthsView>> getMonths(int limit);

  @Query("select * from vw_expense_list where strftime('%Y', created_date)=:year and strftime('%M', created_date)=:month")
  Future<List<Expense>> getExpensesByYearAndMonth(int year, int month);

  @Query('select * from vw_expense_summary where year=:year and month=:month')
  Future<ExpenseMonthsView?> getMonthSummary(int year, int month);

  Stream<List<dynamic>> streamExpensesAndSummaries(int months) async* {
    final ympairs = await getMonths(months);

    for(var m in ympairs.reversed){
      yield await getExpensesByYearAndMonth(m.year, m.month);
      yield [await getMonthSummary(m.year, m.month)];
    }
  }

  @Query('select * from expense where id=:id')
  Future<Expense?> findExpenseById(int id);

  @Query('select * from vw_expense_list where id=:id')
  Future<ExpenseListView?> getViewDataForExpenseId(int id);

  @Query('select count(*) from expenses')
  Future<int?> getExpenseCount();


  @Query('select count(*) from expense_tags')
  Future<int?> getAllExpenseTagCount();

  @Query('select * from expenses where id > :lastId order by id limit :batchSize')
  Future<List<Expense>> getExpenseBatch(int batchSize, int lastId);

  @Query('select * from expense_tags where expense_id=:id')
  Future<List<ExpenseTag>> getExpenseTagsByExpenseId(int id);

  Future<(List<ExpenseTag>, int lastId)> getExpenseTagBatch(int batchSize, int lastId) async {
    final expenses = await getExpenseBatch(batchSize, lastId);
    final newLastId = expenses.lastOrNull?.id ?? lastId;

    final ets = <ExpenseTag>[];
    for(final e in expenses){
      ets.addAll(await getExpenseTagsByExpenseId(e.id!));
    }

    return (ets, newLastId);
  }
}