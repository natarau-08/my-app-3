import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/utils.dart';

class EditCarPage extends StatefulWidget {
  static const String title = 'Edit Car';
  static const String route = '/edit_car';

  final Car? car;

  const EditCarPage({super.key, this.car});

  @override
  State<EditCarPage> createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final _formKey = GlobalKey<FormState>();
  late Car _car;

  @override
  void initState() {
    _car = widget.car ?? Car.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: widget.car == null ? 'Add Car' : 'Edit Car',
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _car.brand,
                onChanged: (value) => _car.brand = value,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Brand cannot be empty';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: _car.model,
                onChanged: (value) => _car.model = value,
                decoration: const InputDecoration(
                  labelText: 'Model',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Model cannot be empty';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                initialValue: _car.year == 0 ? '' : _car.year.toString(),
                onChanged: (value) => _car.year = int.tryParse(value) ?? 0,
                decoration: const InputDecoration(
                  labelText: 'Year',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Year cannot be empty';
                  }
                  final year = int.tryParse(value);
                  if (year == null || year < 1886 || year > DateTime.now().year + 1) {
                    return 'Enter a valid year';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                initialValue: _car.odometer == 0 ? '' : _car.odometer.toString(),
                onChanged: (value) => _car.odometer = int.tryParse(value) ?? 0,
                decoration: const InputDecoration(
                  labelText: 'Odometer (km)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Odometer cannot be empty';
                  }
                  final odometer = int.tryParse(value);
                  if (odometer == null || odometer < 0) {
                    return 'Enter a valid odometer reading';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      if(_car.id == null){
                        await AppDatabase.instance.carDao.insertCar(_car);
                      } else {
                        await AppDatabase.instance.carDao.updateCar(_car);
                      }
                    } catch (e) {
                      Utils.errorMessage(e.toString());
                    }
                    if(context.mounted){
                      Navigator.of(context).pop();
                    }
                  }
                },
                icon: const Icon(Icons.save),
                label: Text(widget.car == null ? 'Add Car' : 'Save Changes'),
              ),
            ],
          ),
        ),
      )
    );
  }
}