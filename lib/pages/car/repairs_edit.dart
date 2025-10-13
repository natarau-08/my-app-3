
import 'package:flutter/material.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/pages/car/expanding_widget.dart';

class RepairsEdit extends StatefulWidget {
  final Car car;

  const RepairsEdit({super.key, required this.car});

  @override
  State<RepairsEdit> createState() => _RepairsEditState();
}

class _RepairsEditState extends State<RepairsEdit> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return ExpandingWidget(
      open: _open,
      title: 'Repairs',
      onTap: (){
        setState(() {
          _open = !_open;
        });
      },
      children: [
        Text('todo')
      ]
    );
  }
}