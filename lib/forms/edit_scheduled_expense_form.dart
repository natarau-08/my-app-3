

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app_3/forms/edit_expense_form.dart';
import 'package:my_app_3/utils.dart';

import '../floor/tables/expense.dart';
import '../floor/tables/scheduled_expense.dart';
import '../floor/tables/tag.dart';

class EditScheduledExpenseForm extends StatefulWidget {
  final ScheduledExpense? data;
  final FutureOr<void> Function(ScheduledExpense data, List<Tag> tags) onSaving;

  const EditScheduledExpenseForm({
    super.key,
    this.data,
    required this.onSaving,
  });

  @override
  State<EditScheduledExpenseForm> createState() => _EditScheduledExpenseFormState();
}

class _EditScheduledExpenseFormState extends State<EditScheduledExpenseForm> {
  late DateTime _startDate;

  var _rp = _RepPat.none;

  final _tev = TextEditingController();

  @override
  void initState() {
    if(widget.data == null){
      _startDate = DateTime.now();
      _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day, _startDate.hour, _startDate.minute, 0);
    }else{
      final data = widget.data!;
      _startDate = data.nextInsert;
      if(data.repeatDaily){
        _rp = _RepPat.daily;
      }else if(data.repeatWeekly){
        _rp = _RepPat.weekly;
      }else if(data.repeatMonthly){
        _rp = _RepPat.monthly;
      }else if(data.repeatYearly){
        _rp = _RepPat.yearly;
      }
    }

    _tev.text = Utils.formatDateTimeLong(_startDate);
    super.initState();
  }

  @override
  void dispose() {
    _tev.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditExpenseForm(
      expenseData: widget.data == null ? null : Expense(
        id: widget.data!.id,
        value: widget.data!.value,
        createdDate: widget.data!.createdDate,
        details: widget.data!.details,
        generated: null
      ),
      onSaving: _onSaving,
      detailsValidator: (str) {
        if(str == null || str.trim().isEmpty){
          return 'Details are required.';
        }
        return null;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 8.0,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                          'Repeat expense every:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),

                const Divider(height: 1,),

                _RadioW(text: 'Day', val: _RepPat.daily, groupVal: _rp, onChanged: _onRadioChecked),
                _RadioW(text: 'Week', val: _RepPat.weekly, groupVal: _rp, onChanged: _onRadioChecked),
                _RadioW(text: 'Month', val: _RepPat.monthly, groupVal: _rp, onChanged: _onRadioChecked),
                _RadioW(text: 'Year', val: _RepPat.yearly, groupVal: _rp, onChanged: _onRadioChecked),
              ],
            ),
          ),

          const SizedBox(height: 8.0,),
          const Text("Repeat start date:"),
          TextField(
            controller: _tev,
            readOnly: true,
            onTap: () async {
              final now = DateTime.now();
              final date = await showDatePicker(context: context, firstDate: DateTime(now.year - 10), lastDate: DateTime(now.year + 10), currentDate: now, initialDate: now);
              if(date == null || !context.mounted) return;

              final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
              if(time == null || !context.mounted) return;

              _startDate = DateTime(date.year, date.month, date.day, time.hour, time.minute, 0, 0);
              _tev.text = Utils.formatDateTimeLong(_startDate);
            }
          ),

          const SizedBox(height: 8.0,),

          Row(
            children: [
              const Text('Next insert: '),
              Text(
                  _getNextInsertString(),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600]
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getNextInsertString(){
    var next = _startDate.copyWith();
    var now = DateTime.now();
    var sb = StringBuffer();

    do {
      switch(_rp){
        case _RepPat.none:
          return '';

        case _RepPat.daily:
          next = next.add(const Duration(hours: 24));
          break;

        case _RepPat.weekly:
          next = next.add(const Duration(days: 7));
          break;

        case _RepPat.monthly:
          next = Utils.addMonths(next, 1);
          break;

        case _RepPat.yearly:
          next = Utils.addMonths(next, 12);
          break;
      }
      sb.writeln(Utils.formatDateTimeLong(next));
    }while(next.isBefore(now));

    var str = sb.toString();
    return str.substring(0, str.length - 1);
  }

  void _onRadioChecked(_RepPat value){
    setState(() {
      _rp = value;
    });
  }

  void _onSaving(Expense ed, List<Tag> tags) {
    if(_rp == _RepPat.none){
      Utils.warningMessage('Please choose a repeat pattern.');
      return;
    }

    final schData = ScheduledExpense(
        id: widget.data == null ? 0 : widget.data!.id,
        value: ed.value,
        createdDate: widget.data == null ? DateTime.now() : widget.data!.createdDate,
        details: ed.details ?? '<no_details>',
        nextInsert: _startDate,
        repeatPattern: ScheduledExpense.buildRepeatPattern(_rp == _RepPat.daily, _rp == _RepPat.weekly, _rp == _RepPat.monthly, _rp == _RepPat.yearly)
    );

    widget.onSaving(schData, tags);
  }
}

class _RadioW extends StatelessWidget {
  final String text;
  final _RepPat groupVal;
  final _RepPat val;
  final void Function(_RepPat value) onChanged;

  const _RadioW({
    required this.text,
    required this.val,
    required this.groupVal,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Text(text)),
          Radio(value: val, groupValue: groupVal, onChanged: (value){ onChanged(value ?? _RepPat.none); })
        ],
      ),
    );
  }
}

// repeat pattern
enum _RepPat {
  none, daily, weekly, monthly, yearly
}