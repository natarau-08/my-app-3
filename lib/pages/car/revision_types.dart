
import 'package:flutter/material.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/controls/elevated_cancel_button.dart';
import 'package:my_app_3/controls/elevated_delete_button.dart';
import 'package:my_app_3/controls/elevated_save_button.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/floor/tables/car_revision_type.dart';
import 'package:my_app_3/pages/car/expanding_widget.dart';
import 'package:my_app_3/utils.dart';

class RevisionTypes extends StatefulWidget {
  final Car car;

  const RevisionTypes({super.key, required this.car});

  @override
  State<RevisionTypes> createState() => _RevisionTypesState();
}

class _RevisionTypesState extends State<RevisionTypes> {
  bool _open = false;
  CarRevisionType? _editing;
  final _editFormKey = GlobalKey<FormState>();

  Stream<List<CarRevisionType>>? _stream;

  @override
  Widget build(BuildContext context) {
    return ExpandingWidget(
      open: _open,
      title: 'Revision types',
      onTap: () => setState(() {
        _open = !_open;
        _editing = null;
      }),
      children: [
        // Adding / editing an entry
        if(_editing != null) ... [
          const Divider(height: 1,),
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _editFormKey,
              child: Column(
                children: [
                  Text(_editing!.id == null ? 'Add revision type' : 'Edit revision type', style: Theme.of(context).textTheme.titleMedium,),
                  TextFormField(
                    initialValue: _editing!.name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    onChanged: (value) => _editing!.name = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16,),

                  TextFormField(
                    initialValue: _editing!.intervalKm?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Interval (km)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _editing!.intervalKm = int.tryParse(value),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final v = int.tryParse(value);
                        if (v == null || v <= 0) {
                          return 'Interval must be a positive integer or empty';
                        }
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16,),

                  TextFormField(
                    initialValue: _editing!.intervalMonths?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Interval (months)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _editing!.intervalMonths = int.tryParse(value),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final v = int.tryParse(value);
                        if (v == null || v <= 0) {
                          return 'Interval must be a positive integer or empty';
                        }
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedSaveButton(onPressed: () async {
                        if(!(_editFormKey.currentState?.validate() ?? false)){
                          return;
                        }

                        try{
                          if(_editing!.id == null){
                            await AppDatabase.instance.carRevisionDao.insertType(_editing!);
                          }
                          else{
                            await AppDatabase.instance.carRevisionDao.updateType(_editing!);
                          }

                          if(mounted){
                            setState(() {
                              _editing = null;
                            });
                          }
                        }catch(e){
                          if(mounted){
                            Utils.errorMessage(e.toString());
                          }
                        }
                      }),
                      
                      const SizedBox(width: 32,),
                      
                      ElevatedCancelButton(onPressed: (){
                        setState(() {
                          _editing = null;
                        });
                      }),
                      
                      if(_editing!.id != null) ... [

                        const SizedBox(width: 32,),

                        ElevatedDeleteButton(onPressed: () async {
                          try{
                            if(!await Utils.confirm(context, 'Delete ${_editing!.name}?', null)){
                              return;
                            }
                            
                            await AppDatabase.instance.carRevisionDao.deleteType(_editing!);

                            if(mounted){
                              Utils.successMessage('Revision type deleted');
                              setState(() {
                                _editing = null;
                              });
                            }
                          }catch(e){
                            if(mounted){
                              Utils.errorMessage(e.toString());
                            }
                          }
                        })
                      ]
                    ],
                  ),

                ],
              ),
            ),
          ),
          // const Divider(height: 1,),
        ]

        // List of entries
        else ...[
          const Divider(height: 1,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Builder(builder: (context){
                  _stream ??= AppDatabase.instance.carRevisionDao.findRevisionTypesByCarId(widget.car.id!);
                  return StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot){
                      final w = SimpleProgressIndicator.handleSnapshotForLoadingOrError(snapshot);
                      if(w != null){
                        return w;
                      }
                
                      final items = snapshot.data as List<CarRevisionType>;
                
                      if(items.isEmpty){
                        return NoDataAvailableCenteredWidget();
                      }
                
                      return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          final item = items[index];
                
                          late String text;
                          if(item.intervalKm != null && item.intervalMonths != null){
                            text = 'Every ${item.intervalKm} km or ${item.intervalMonths} months';
                          }
                          else if(item.intervalKm != null){
                            text = 'Every ${item.intervalKm} km';
                          }
                          else if(item.intervalMonths != null){
                            text = 'Every ${item.intervalMonths} months';
                          }
                          else{
                            text = 'No interval set';
                          }
                
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text(text),
                            onTap: () {
                              setState(() {
                                _editing = item;
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(height: 1,),
                        itemCount: items.length,
                      );
                    }
                  );
                }),

                const SizedBox(height: 16,),

                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _editing = CarRevisionType(carId: widget.car.id!, name: '');
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add revision type')
                )
              ],
            )
          ),
          // const Divider(height: 1,),
        ]
      ],
    );
  }
}