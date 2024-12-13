
import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/pages/edit_scheduled_expense_page.dart';

import '../database/database.dart';

class ScheduledExpensesPage extends StatefulWidget {
  static const route = '/expenses/scheduled';
  static const title = 'Scheduled expenses';

  const ScheduledExpensesPage({super.key});

  @override
  State<ScheduledExpensesPage> createState() => _ScheduledExpensesPageState();
}

class _ScheduledExpensesPageState extends State<ScheduledExpensesPage> {

  late Stream<List<ScheduledExpenseData>> _stream;


  @override
  void initState() {
    _stream = AppDatabase().scheduledExpenseDao.watchScheduledExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: ScheduledExpensesPage.title,
      actions: [
        IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditScheduledExpensePage.route),
            icon: const Icon(Icons.edit_calendar)
        ),
      ],
      child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            final t = SimpleProgressIndicator.handleSnapshotForLoadingOrError(snapshot);
            if(t != null){
              return t;
            }

            final items = snapshot.data!;

            if(items.isEmpty){
              return const NoDataAvailableCenteredWidget();
            }

            return ListView.separated(
              itemCount: items.length,

              separatorBuilder: (context, index) {
                return const Divider(height: 1,);
              },

              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(EditScheduledExpensePage.route, arguments: item);
                  },
                  title: Text(item.details ?? 'no details'),
                  subtitle: Text(item.value.toString()),
                );
              },
            );
          },
      )
    );
  }
}