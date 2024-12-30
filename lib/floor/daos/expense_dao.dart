
import 'package:floor/floor.dart';
import 'package:my_app_3/floor/tables/expense.dart';
import 'package:my_app_3/floor/tables/expense_tag.dart';
import 'package:my_app_3/floor/tables/tag.dart';
import 'package:my_app_3/floor/views/expense_list_view.dart';
import 'package:my_app_3/floor/views/expense_month_summary_view.dart';
import 'package:my_app_3/floor/views/expense_months_view.dart';

@dao
abstract class ExpenseDao {

  @Query("""select
  t.*
from expense_tags et
join tags t on t.id = et.tag_id
where et.expense_id = :id""")
  Future<List<Tag>> getTagsForExpenseId(int id);

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

  @Query('delete from expense_tags where expense_id = :eid')
  Future<int?> deleteExpenseTagForExpenseId(int eid);

  @Insert()
  Future<void> insertExpenseTagList(List<ExpenseTag> data);

  @transaction
  Future<void> setExpenseTags(List<Tag> tags, int expenseId) async {
    await deleteExpenseTagForExpenseId(expenseId);
    final list = tags.map((x) => ExpenseTag(tagId: x.id, expenseId: expenseId)).toList();
    await insertExpenseTagList(list);
  }

  @transaction
  Future<void> saveExpenseWithTags(Expense e, List<Tag> tags) async {
    final id = await saveExpense(e);
    
    assert (id != 0, "Expense id cannot be 0 after an insert!");
    
    await setExpenseTags(tags, id);
  }

  @Insert()
  Future<void> batchInsertExpenseTags(List<ExpenseTag> rows);

  @Query('select * from vw_expense_months order by year desc, month desc limit :limit')
  Future<List<ExpenseMonthsView>> getMonths(int limit);

  @Query("select * from vw_expense_list where year=:year and month=:month")
  Future<List<ExpenseListView>> getExpensesByYearAndMonth(int year, int month);

  @Query('select * from vw_expense_summary where year=:year and month=:month')
  Future<ExpenseMonthSummaryView?> getMonthSummary(int year, int month);

  Stream<List<dynamic>> streamExpensesAndSummaries(int months) async* {
    final ympairs = await getMonths(months);

    for(var m in ympairs.reversed){
      yield await getExpensesByYearAndMonth(m.year, m.month);
      final summary = await getMonthSummary(m.year, m.month);
      if(summary != null) {
        yield [summary];
      }
    }
  }

  @Query('select * from expenses where id=:id')
  Future<Expense?> findExpenseById(int id);

  @Query('select * from vw_expense_list where id=:id')
  Future<ExpenseListView?> getViewDataForExpenseId(int id);
}