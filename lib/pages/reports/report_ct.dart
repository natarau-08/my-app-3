

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app_3/app_assets.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/utils.dart';

class ReportCt extends StatefulWidget {
  static String title = 'Costs by tags report';
  static String route = '/rep/ct';

  const ReportCt({super.key});

  @override
  State<ReportCt> createState() => _ReportCtState();
}

class _ReportCtState extends State<ReportCt> {
  late int _month;
  late int _year;
  late Future<List<Map<String, dynamic>>> _future;

  Future<List<Map<String, dynamic>>> _runReport() async {
    final startDate = DateTime(_year, _month, 1);
    final endDate = Utils.addMonths(startDate, 1);

    return await AppDatabase.instance.database.database.rawQuery(
      await AppAssets.loadSql('report_ct'),
      [startDate.toIso8601String(), endDate.toIso8601String()]
    ) as List<Map<String, dynamic>>;
  }

  @override
  void initState() {
    final now = DateTime.now();
    _month = now.month;
    _year = now.year;
    _future = _runReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: ReportCt.title,
      actions: [
        IconButton(
          onPressed: () async {
            final pair = await showModalBottomSheet(
              context: context,
              useSafeArea: true,
              builder: (context) => _Filter(_year, _month)
            );

            if(pair == null){
              return;
            }

            final (int year, int month) = pair;

            setState(() {
              _year = year;
              _month = month;
              _future = _runReport();
            });
          },
          icon: const Icon(Icons.filter_alt)
        )
      ],
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot){
          final w = SimpleProgressIndicator.handleSnapshotForLoadingOrError(snapshot);
          if(w != null){
            return w;
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Tag')),
                    DataColumn(label: Text('Gain'), numeric: true),
                    DataColumn(label: Text('Loss'), numeric: true),
                    DataColumn(label: Text('Total'), numeric: true),
                  ],
                  rows: [for(final x in data) DataRow(
                    cells: [
                      DataCell(Text(x['crtNo'].toString())),
                      DataCell(Text(x['tagName'] as String? ?? '')),
                      DataCell(Text((x['gain'] as num).toStringAsFixed(2))),
                      DataCell(Text((x['loss'] as num).toStringAsFixed(2))),
                      DataCell(Text((x['total'] as num).toStringAsFixed(2))),
                    ]
                  )]
                ),
              ],
            ),
          );
        }
      )
    );
  }
}

class _Filter extends StatefulWidget {
  final int year;
  final int month;

  const _Filter(this.year, this.month);

  @override
  State<_Filter> createState() => _FilterState();
}

class _FilterState extends State<_Filter> {
  final _yCtrl = TextEditingController();
  final _mCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _yCtrl.text = widget.year.toString();
    _mCtrl.text = widget.month.toString().padLeft(2, '0');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _yCtrl.dispose();
    _mCtrl.dispose();
  }

  void _onFilter(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    
    try{
      int month = int.parse(_mCtrl.text);
      int year = int.parse(_yCtrl.text);
      Navigator.of(context).pop((year, month));
    }catch(e){
      Utils.errorMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170 + MediaQuery.of(context).viewInsets.bottom,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 32, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          spacing: 16,
          children: [
            Form(
              key: _formKey,
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _yCtrl,
                      decoration: InputDecoration(
                        helperText: 'Year'
                      ),
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Year is required';
                        }

                        if(value.length != 4){
                          return 'Year must be exactly 4 digits long';
                        }

                        try{
                          int year = int.parse(value);
                          if(year < 1970){
                            return 'Space-time continuum started at 1970-01-01 00:00 UTC.';
                          }
                        }catch(e){
                          return e.toString();
                        }

                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _mCtrl,
                      decoration: InputDecoration(
                        helperText: 'Month'
                      ),
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Month is required';
                        }

                        if(value.length > 2){
                          return 'Month must be 2 characters long.';
                        }

                        try{
                          int month = int.parse(value);
                          if(month < 1 || month > 12){
                            return 'Month must be between 1 and 12.';
                          }
                        }catch(e){
                          return e.toString();
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onFilter,
                    child: Text('Filter'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
