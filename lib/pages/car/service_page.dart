

import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/pages/car/edit_car_page.dart';
import 'package:my_app_3/pages/car/repairs_edit.dart';
import 'package:my_app_3/pages/car/revision_types.dart';
import 'package:my_app_3/pages/car/revisions_edit.dart';

class ServicePage extends StatefulWidget {
  final Car car;

  const ServicePage({super.key, required this.car});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late final _revisionTypesStream = AppDatabase.instance.carRevisionDao.streamTypesByCarId(widget.car.id!);

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: '${widget.car.brand} ${widget.car.model} service info',
      child: ListView(
        children: [
          ListTile(
            title: const Text('Edit car properties'),
            subtitle: Text('Brand: ${widget.car.brand}, Model: ${widget.car.model}, Year: ${widget.car.year}'),
            trailing: const Icon(Icons.edit),
            onTap: () => _editCar(context),
          ),
          const Divider(height: 1,),
          RevisionTypes(widget.car, _revisionTypesStream),
          const Divider(height: 1,),
          RevisionsEdit(widget.car, _revisionTypesStream),
          const Divider(height: 1,),
          RepairsEdit(car: widget.car),
        ],
      ),
    );
  }

  void _editCar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCarPage(car: widget.car),
      ),
    );
  }
}