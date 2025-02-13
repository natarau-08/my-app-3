
import 'package:flutter/material.dart';
import 'package:my_app_3/app_main_page.dart';
import 'package:my_app_3/pages/reports/report_ct.dart';
import 'package:my_app_3/pages/reports/report_expense_tag_tracking_list.dart';

class ReportsPage extends StatelessWidget {
  static const String title = 'Reports';
  static const String route = '/rep';

  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppMainPage(
      title: title,
      body: ListView(
        children: [
          _ReportItem(
            'Costs by tags',
            'How much money you spent (costs), by each tag in a month. An expense with two tags will be count twice.',
            onTap: () => Navigator.of(context).pushNamed(ReportCt.route),
          ),

          Divider(height: 1,),

          _ReportItem(
            'Expense tag tracking reports',
            'Track expenses by tags. You can pin a tracking report to the home screen.',
            onTap: () => Navigator.of(context).pushNamed(ReportExpenseTagTrackingList.route),
          )
        ],
      )
    );
  }
}

class _ReportItem extends StatelessWidget {
  final String _title;
  final String _subtitle;
  final Function() onTap;

  const _ReportItem(this._title, this._subtitle, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_title),
      subtitle: Text(_subtitle),
      onTap: onTap,
    );
  }
}