
import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';

import '../../controls/centered_widgets.dart';
import '../../floor/app_database.dart';
import '../../floor/tables/tag_tracking.dart';
import 'report_expense_tag_tracking_edit.dart';

class ReportExpenseTagTrackingList extends StatefulWidget{
  static const route = '/rep/ett/list';

  const ReportExpenseTagTrackingList({super.key});

  @override
  State<ReportExpenseTagTrackingList> createState() => _ReportExpenseTagTrackingListState();
}

class _ReportExpenseTagTrackingListState extends State<ReportExpenseTagTrackingList> {
  final _stream = AppDatabase.instance.tagTrackingDao.streamAllTagTrackings();

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: 'Expense tag tracking (WIP)',
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed(ReportExpenseTagTrackingEdit.route),
          icon: const Icon(Icons.add)
        )
      ],
      child: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot){
          final w = SimpleProgressIndicator.handleSnapshotForLoadingOrError(snapshot);
          if(w != null){
            return w;
          }

          final data = snapshot.data as List<TagTracking>;

          return ListView.separated(
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                onTap: () => Navigator.of(context).pushNamed(ReportExpenseTagTrackingEdit.route, arguments: item)
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 0.5,),
            itemCount: data.length
          );
        }
      )
    );
  }
}