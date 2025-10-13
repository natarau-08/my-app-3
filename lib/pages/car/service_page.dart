

import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/pages/car/edit_car_page.dart';
import 'package:my_app_3/pages/car/repairs_edit.dart';
import 'package:my_app_3/pages/car/revision_types.dart';
import 'package:my_app_3/pages/car/revisions_edit.dart';

class ServicePage extends StatelessWidget {
  final Car car;

  const ServicePage({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: '${car.brand} ${car.model} service info',
      child: ListView(
        children: [
          ListTile(
            title: const Text('Edit car properties'),
            subtitle: Text('Brand: ${car.brand}, Model: ${car.model}, Year: ${car.year}'),
            trailing: const Icon(Icons.edit),
            onTap: () => _editCar(context),
          ),
          const Divider(height: 1,),
          RevisionTypes(car: car),
          const Divider(height: 1,),
          RevisionsEdit(car: car,),
          const Divider(height: 1,),
          RepairsEdit(car: car),
        ],
      ),
    );
  }

  void _editCar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCarPage(car: car),
      ),
    );
  }
}