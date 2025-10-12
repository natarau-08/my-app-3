
import 'package:flutter/material.dart';
import 'package:my_app_3/app_main_page.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/pages/edit_car_page.dart';
import 'package:my_app_3/utils.dart';

class CarPage extends StatefulWidget {
  static const String route = '/car';
  static const String title = 'Cars';

  const CarPage({super.key});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  Stream<List<Car>>? _stream;

  @override
  void initState() {
    _stream = AppDatabase.instance.carDao.findAllCars();    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppMainPage(
      title: CarPage.title,
      actions: [
        IconButton(
          onPressed: () {
            // TODO: implement settings
            Utils.infoMessage('Not implemented yet');
          },
          icon: const Icon(Icons.settings)
        ),
        IconButton(
          onPressed: (){
            _editCar();
          },
          icon: const Icon(Icons.add)
        )
      ],
      body: _stream == null ? SimpleInfoIndicator('Loading...') : StreamBuilder(
        stream: _stream,
        builder: (context, snapshot){
          final w = SimpleProgressIndicator.handleSnapshotForLoadingOrError(snapshot);
          if(w != null){
            return w;
          }

          final items = snapshot.data as List<Car>;

          if(items.isEmpty){
            return SimpleVerticalCenteredWidget(
                children: [
                  const Icon(Icons.car_crash, size: 64, color: Colors.grey,),
                  const Text("No cars added."),
                  IconButton(
                    onPressed: (){
                      _editCar();
                    },
                    icon: const Icon(Icons.add)
                  ) 
                ],
            );
          }

          return ListView.separated(
            itemBuilder: (context, index){
              final item = items[index];
              
              return ListTile(
                title: Text('${item.brand} ${item.model} (${item.year})'),
                subtitle: Text('${item.odometer}km'),
                onTap: () {
                  _editCar(car: item);
                },
              );

            },
            separatorBuilder: (contex, index) => const Divider(height: 1,),
            itemCount: items.length
          );
        }
      )
    );
  }

  void _editCar({Car? car}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCarPage(car: car)
      )
    );
  }
}

