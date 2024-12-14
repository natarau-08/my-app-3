
import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/floor/tables/expense.dart';
import 'package:my_app_3/forms/edit_expense_form.dart';

import '../constants.dart';
import '../floor/app_database.dart';

class EditExpensePage extends StatelessWidget {
  static const String title = 'Edit Expense';
  static const String route = '/expenses/edit_expense';

  const EditExpensePage({super.key});

  @override
  Widget build(BuildContext context) {

    final expense = ModalRoute.of(context)!.settings.arguments as Expense?;

    if(expense == null){
      return const AppSecondaryPage(
        title: title,
        child: SimpleErrorIndicator('No args where passed to route.')
      );
    }

    return AppSecondaryPage(
      title: title,
      child: Padding(
        padding: const EdgeInsets.all(Constants.pagePadding),
        child: EditExpenseForm(
          expenseData: expense,
          onSaving: (expenseData, tags) async {
            await AppDatabase.instance.expenseDao.saveExpense(expenseData);
            await AppDatabase.instance.expenseDao.setTags(tags, expenseData.id!);
            if(context.mounted){
              Navigator.of(context).pop();
            }
          },
        ),
      )
    );
  }
}