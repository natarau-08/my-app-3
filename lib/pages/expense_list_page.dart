
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app_3/app_main_page.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/floor/tables/expense.dart';
import 'package:my_app_3/floor/views/expense_month_summary_view.dart';
import 'package:my_app_3/pages/add_expense_page.dart';
import 'package:my_app_3/pages/edit_expense_page.dart';

import '../floor/app_database.dart';
import '../floor/views/expense_list_view.dart';
import '../utils.dart';

class ExpenseListPage extends StatefulWidget {
  static const String title = 'Expense List';
  static const String route = '/expense-list';

  static void Function()? onExpensesChangedCallback;

  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  late List<dynamic> _data;
  StreamSubscription<List<dynamic>>? _subscription;
  late ScrollController _scrollController;
  
  @override
  void initState(){
    _scrollController = ScrollController();

    _refreshData();

    ExpenseListPage.onExpensesChangedCallback = _refreshData;

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _scrollController.dispose();

    ExpenseListPage.onExpensesChangedCallback = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final cs = Theme.of(context).colorScheme;

    return AppMainPage(
      title: ExpenseListPage.title,
      
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed(AddExpensePage.route),
          icon: const Icon(Icons.add)
        )
      ],

      body: _data.isEmpty ? const NoDataAvailableCenteredWidget()
      : ListView.separated(
        controller: _scrollController,
        itemCount: _data.length,
        itemBuilder: (context, index){
          final item = _data[index];
          
          if(item is ExpenseListView){
            final String addLabel = item.generated == null ? 'Added' : 'Generated';
            return ListTile(
              onTap: () async {
                final expense = await AppDatabase.instance.expenseDao.findExpenseById(item.id);
                if(context.mounted){
                  final result = await Navigator.of(context).pushNamed(EditExpensePage.route, arguments: expense) as Expense?;
                  
                  if(result != null) {
                    final updatedData = await AppDatabase.instance.expenseDao.getViewDataForExpenseId(result.id!);
                    setState(() {
                      _data[index] = updatedData;
                    });
                  }
                }
              },
              tileColor: index % 2 == 0 ? cs.surface : cs.inversePrimary,
              title: Wrap(
                children: [
                  Text(item.value.toString(),),
                  if(item.firstTag != null) ...[
                    const SizedBox(width: 10,),
                    Chip(
                      padding: const EdgeInsets.all(0),
                      label: Text(item.firstTag!)
                    ),
                    if(item.totalTags > 1) Text(
                      ' (+${item.totalTags - 1})',
                      style: const TextStyle(
                        fontSize: 14
                      ),
                    )
                  ]
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(item.details != null) Text(item.details!),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$addLabel: ${Utils.formatDateTimeLong(item.createdDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if(item is ExpenseMonthSummaryView){
            return ListTile(
              tileColor: cs.secondary,
              title: Row(
                children: [
                  Expanded(child: Text('Total month: ${item.totalMonth}', style: TextStyle(color: cs.onSecondary),)),
                  Text('${item.month}/${item.year}', style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSecondary),)
                ],
              ),
              subtitle: Row(
                children: [
                  Text('Balance: ${item.totalMonthGain} / ${item.totalMonthLoss}', style: TextStyle(color: cs.onSecondary),),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('${_data.length} expenses', style: TextStyle(color: cs.onSecondary),)
                    ),
                  )
                ],
              ),
            );
          } else {
            return ListTile(
              title: Text('invalid_item: $item'),
            );
          }
        },
        separatorBuilder: (context, index) => const Divider(height: 1,),
      )
    );
  }

  void _refreshData() async {
    _data = [];

    await _subscription?.cancel();

    _subscription = AppDatabase.instance.expenseDao.streamExpensesAndSummaries(3).listen((data){
      _data.addAll(data);
    });

    _subscription!.onDone((){
      if(_data.isEmpty) return;
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_){
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 3 * _data.length),
              curve: Curves.easeInOut
          );
        });
      });
    });
  }
}