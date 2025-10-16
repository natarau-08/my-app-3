

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;
  final DateTime? initialDateTime;
  final String? label;

  const DateTimePicker({super.key, this.label, this.initialDateTime, required this.onDateTimeChanged});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final _controller = TextEditingController();
  final _df = DateFormat('dd/MM/yyyy HH:mm');
  
  DateTime? _dateTime;

  @override
  void initState() {
    if(widget.initialDateTime != null) {
      _dateTime = widget.initialDateTime!;
    }
    
    super.initState();

    _setText(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      showCursor: false,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        labelText: widget.label ?? 'Select date and time',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: _dateTime ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (date != null && context.mounted) {
          TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: _dateTime != null ? TimeOfDay.fromDateTime(_dateTime!) : TimeOfDay.now(),
          );

          if (time != null) {
            final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
            _setText(dateTime);
            widget.onDateTimeChanged(dateTime);
          }
        }
      },
    );
  }

  void _setText(DateTime? dt) {
    if(dt == null) {
      _controller.text = '';
      return;
    }
    _controller.text = _df.format(dt);
  }
}