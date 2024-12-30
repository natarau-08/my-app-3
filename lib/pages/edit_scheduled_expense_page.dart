
import 'package:flutter/cupertino.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/forms/edit_scheduled_expense_form.dart';

import '../constants.dart';
import '../floor/app_database.dart';
import '../floor/tables/scheduled_expense.dart';
import '../utils.dart';

class EditScheduledExpensePage extends StatefulWidget {
  static const String route = '/edit-sch-exp';


  const EditScheduledExpensePage({
    super.key
  });

  @override
  State<EditScheduledExpensePage> createState() => _EditScheduledExpensePageState();
}

class _EditScheduledExpensePageState extends State<EditScheduledExpensePage> {
  ScheduledExpense? _scheduledExpenseData;

  @override
  Widget build(BuildContext context) {

    _scheduledExpenseData = ModalRoute.of(context)!.settings.arguments as ScheduledExpense?;

    return AppSecondaryPage(
        title: _scheduledExpenseData == null ? 'Add scheduled expense' : 'Edit scheduled expense',
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Constants.pagePadding),
            child: EditScheduledExpenseForm(
              onSaving: (data, tags) async {
                try{
                  await AppDatabase.instance.scheduledExpenseDao.saveScheduledExpense(data, tags);
                  await AppDatabase.instance.scheduledExpenseDao.generateExpenses();

                  Utils.successMessage('Scheduled expense saved!');

                  if(context.mounted){
                    Navigator.of(context).pop();
                  }
                }catch(ex){
                  Utils.errorMessage(ex.toString());
                }
              },
              data: _scheduledExpenseData,
            ),
          ),
        )
    );
  }
}