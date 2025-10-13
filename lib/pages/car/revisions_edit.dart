
import 'package:flutter/material.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/floor/tables/car_revision.dart';
import 'package:my_app_3/pages/car/expanding_widget.dart';

class RevisionsEdit extends StatefulWidget {
  final Car car;

  const RevisionsEdit({super.key, required this.car});

  @override
  State<RevisionsEdit> createState() => _RevisionsEditState();
}

class _RevisionsEditState extends State<RevisionsEdit> {
  bool _open = false;
  CarRevision? _editing;

  @override
  Widget build(BuildContext context) {
    return ExpandingWidget(
      open: _open,
      title: 'Revisions',
      onTap: (){
        setState(() {
          _open = !_open;
          _editing = null;
        });
      },
      children: [
        Text('todo')
      ]
    );
  }
}