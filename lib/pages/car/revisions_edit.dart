
import 'package:flutter/material.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/controls/date_time_picker.dart';
import 'package:my_app_3/controls/elevated_cancel_button.dart';
import 'package:my_app_3/controls/elevated_delete_button.dart';
import 'package:my_app_3/controls/elevated_save_button.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/floor/tables/car_revision.dart';
import 'package:my_app_3/floor/tables/car_revision_type.dart';
import 'package:my_app_3/model/revision_model.dart';
import 'package:my_app_3/pages/car/expanding_widget.dart';
import 'package:my_app_3/utils.dart';

class RevisionsEdit extends StatefulWidget {
  final Car car;

  const RevisionsEdit(this.car, {super.key});

  @override
  State<RevisionsEdit> createState() => _RevisionsEditState();
}

class _RevisionsEditState extends State<RevisionsEdit> {
  late final _ctStream = AppDatabase.instance.carRevisionDao.streamTypesByCarId(widget.car.id!);

  final _formKey = GlobalKey<FormState>();

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
        if(_editing == null) ...[
          const Divider(height: 1,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                StreamBuilder(
                  stream: RevisionModel.streamByCarId(widget.car.id!),
                  builder: (context, snapshot){
                    final w = SimpleProgressIndicator.handleList(snapshot);
                    if(w != null) return w;

                    final items = snapshot.data!;

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const Divider(height: 1,),
                      itemBuilder: (context, index){
                        final rev = items[index];
                        return ListTile(
                          title: Text(rev.mame),
                          subtitle: Text('Date: ${rev.date}'),
                          onTap: (){
                            setState(() {
                              _editing = rev.revision;
                            });
                          },
                        );
                      }
                    );
                  }
                ),
                const SizedBox(height: 16,),
                ElevatedButton.icon(
                  onPressed: (){
                    setState(() {
                      _editing = CarRevision.create(widget.car.id!);
                    });
                  },
                  label: const Text('Add revision'),
                  icon: const Icon(Icons.add),
                )
              ],
            ),
          )
        ] else ...[
          const Divider(height: 1,),
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(_editing!.id == null ? 'Add revision' : 'Edit revision', style: Theme.of(context).textTheme.titleMedium,),
                  StreamBuilder(
                    stream: _ctStream,
                    builder: (context, asyncSnapshot) {
                      final items = asyncSnapshot.data ?? [];
                      return DropdownMenu<CarRevisionType>(
                        expandedInsets: EdgeInsets.all(0),
                        label: const Text('Revision type'),
                        dropdownMenuEntries: [
                          for(final e in items)
                            DropdownMenuEntry(value: e, label: e.name)
                        ],
                        onSelected: (value) {
                          _editing!.revisionTypeId = value!.id!;
                        },
                      );
                    }
                  ),

                  const SizedBox(height: 16,),

                  TextFormField(
                    initialValue: (_editing!.id == null ? widget.car.odometer : _editing!.odometer).toString(),
                    decoration: const InputDecoration(
                      labelText: 'Odometer (km)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Please enter odometer reading';
                      }
                      final n = int.tryParse(value);
                      if(n == null) {
                        return 'Please enter a valid number';
                      }
                      if(n < 0) {
                        return 'Odometer cannot be negative';
                      }
                      _editing!.odometer = n;
                      return null;
                    },
                  ),

                  const SizedBox(height: 16,),

                  TextFormField(
                    initialValue: _editing!.notes,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                    ),
                    maxLines: null,
                    onChanged: (value) {
                      final v = value.trim();
                      if(v.isEmpty) {
                        _editing!.notes = null;
                      } else {
                        _editing!.notes = v;
                      }
                    },
                  ),

                  const SizedBox(height: 16,),

                  DateTimePicker(
                    initialDateTime: _editing!.date,
                    onDateTimeChanged: (dateTime) {
                      _editing!.date = dateTime;
                    },
                  ),

                  const SizedBox(height: 16,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedSaveButton(
                        onPressed: (){
                          if(!_formKey.currentState!.validate()){
                            return;
                          }

                          _editing!.carId = widget.car.id!;

                          try{
                            if(_editing!.id == null){
                              AppDatabase.instance.carRevisionDao.insertRevision(_editing!);
                            } else {
                              AppDatabase.instance.carRevisionDao.updateRevision(_editing!);
                            }

                            Utils.successMessage('Revision saved');
                            
                            setState(() {
                              _editing = null;
                            });
                          }catch(e){
                            Utils.errorMessage('Failed to save revision: $e');
                            return;
                          }
                        }
                      ),

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
                            if(!await Utils.confirm(context, 'Delete this revision?', null)){
                              return;
                            }

                            await AppDatabase.instance.carRevisionDao.deleteRevision(_editing!);
                            Utils.successMessage('Revision deleted');
                            if(mounted){
                              setState(() {
                                _editing = null;
                              });
                            }
                          }catch(e){
                            Utils.errorMessage('Failed to delete revision: $e');
                          }
                        }),
                      ]
                    ],
                  )
                ],
              )
            ),
          ),
        ]
      ]
    );
  }
}