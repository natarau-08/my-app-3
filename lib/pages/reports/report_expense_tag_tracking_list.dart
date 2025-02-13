
import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';

import '../../controls/centered_widgets.dart';
import 'report_expense_tag_tracking_edit.dart';

class ReportExpenseTagTrackingList extends StatelessWidget{
  static const route = '/rep/ett/list';

  const ReportExpenseTagTrackingList({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: 'Expense tag tracking',
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed(ReportExpenseTagTrackingEdit.route),
          icon: const Icon(Icons.add)
        )
      ],
      child: NotImplementedWidget()
    );
  }
}