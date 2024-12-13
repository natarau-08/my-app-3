
import 'package:flutter/cupertino.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/database/database.dart';
import 'package:my_app_3/forms/edit_scheduled_expense_form.dart';
import 'package:drift/drift.dart' as drift;

import '../constants.dart';
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
  ScheduledExpenseData? _scheduledExpenseData;

  @override
  Widget build(BuildContext context) {

    _scheduledExpenseData = ModalRoute.of(context)!.settings.arguments as ScheduledExpenseData?;

    return AppSecondaryPage(
        title: _scheduledExpenseData == null ? 'Add scheduled expense' : 'Edit scheduled expense',
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Constants.pagePadding),
            child: EditScheduledExpenseForm(
              onSaving: (data, tags) async {
                late ScheduledExpenseCompanion comp;

                if(_scheduledExpenseData == null){
                  comp = data.toCompanion(true).copyWith(id: const drift.Value.absent());
                }else{
                  comp = data.toCompanion(true);
                }

                try{
                  await AppDatabase.instance.transaction(() async {
                    int id = await AppDatabase.scheduledExpensesDao.saveScheduledExpense(comp);

                    await AppDatabase.scheduledExpensesDao.setTags(tags, id);

                    await AppDatabase.scheduledExpensesDao.generateExpenses();
                  });

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