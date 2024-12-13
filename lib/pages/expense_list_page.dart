
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app_3/app_main_page.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/pages/add_expense_page.dart';
import 'package:my_app_3/pages/edit_expense_page.dart';

import '../constants.dart';
import '../database/database.dart';
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
          // final cs = Theme.of(context).colorScheme;
          
          final item = _data[index];
          
          if(item is ExpenseListViewData){
            final String addLabel = item.generated == null ? 'Added' : 'Generated for';
            return ListTile(
              onTap: () async {
                final expense = await AppDatabase.expensesDao.findExpenseById(item.id);
                if(context.mounted){
                  final result = await Navigator.of(context).pushNamed(EditExpensePage.route, arguments: expense) as ExpenseData?;
                  
                  if(result != null) {
                    final updatedData = await AppDatabase.expensesDao.getViewDataForExpenseId(result.id);
                    setState(() {
                      _data[index] = updatedData;
                    });
                  }
                }
              },
              tileColor: index % 2 == 0 ? const Color(0xFFD5FFFD) : const Color.fromARGB(255, 222, 202, 255),
              title: Wrap(
                children: [
                  Text(
                    item.value.toString(),
                    style: TextStyle(
                      color: item.value <= 0 ? Constants.colorExpenseGainText : Colors.red
                    ),
                  ),
                  if(item.firstTag != null) ...[
                    const SizedBox(width: 10,),
                    Chip(
                      padding: const EdgeInsets.all(0),
                      label: Text(item.firstTag!)
                    ),
                    if(item.totalTags != null && item.totalTags! > 1) Text(
                      ' (+${item.totalTags! - 1})',
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
                        color: item.generated == null ? Colors.black45 : Colors.brown,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if(item is ExpenseMonthSummaryViewData){
            return ListTile(
              // tileColor: const Color(0xfff2f2f2),
              tileColor: const Color(0xFF6AD0FF),
              title: Row(
                children: [
                  Expanded(child: Text('Total month: ${item.totalMonth ?? 0}')),
                  Text('${item.month}/${item.year}', style: const TextStyle(fontWeight: FontWeight.bold,),)
                ],
              ),
              subtitle: Row(
                children: [
                  const Text('Balance: '),
                  Text('${((item.totalMonthGain ?? 0) * -1)}', style: const TextStyle(color: Constants.colorExpenseGainText),),
                  const Text(' / '),
                  Text((item.totalMonthLoss ?? 0).toString(), style: const TextStyle(color: Colors.red),),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('${_data.length} expenses')
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

  // <editor-fold desc="Refresh Data" defaultstate="collapsed">
  void _refreshData() async {
    _data = [];

    await _subscription?.cancel();

    _subscription = AppDatabase.expensesDao.streamExpensesAndSummaries(3).listen((data){
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
          // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
    });
  }
  // </editor-fold>
}