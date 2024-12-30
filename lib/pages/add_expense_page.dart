import 'package:flutter/material.dart';
import 'package:my_app_3/app_main_page.dart';
import 'package:my_app_3/forms/edit_expense_form.dart';
import 'package:my_app_3/pages/edit_scheduled_expense_page.dart';
import 'package:my_app_3/pages/expense_list_page.dart';
import 'package:my_app_3/pages/scheduled_expenses_page.dart';

import '../constants.dart';
import '../floor/app_database.dart';

class AddExpensePage extends StatelessWidget {
  static const String title = 'Add Expense';
  static const String route = '/add_expense';

  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppMainPage(
      title: title,
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed(ScheduledExpensesPage.route),
          icon: const Icon(Icons.calendar_month)
        ),

        IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditScheduledExpensePage.route),
            icon: const Icon(Icons.edit_calendar)
        ),

        IconButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed(ExpenseListPage.route),
          icon: const Icon(Icons.list)
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constants.pagePadding),
          child: EditExpenseForm(
              onSaving: (expense, tags) async {
                await AppDatabase.instance.expenseDao.saveExpenseWithTags(expense, tags);
              },
          ),
        ),
      )
    );
  }
}