
import 'package:flutter/material.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/floor/tables/car.dart';
import 'package:my_app_3/floor/tables/car_revision.dart';
import 'package:my_app_3/floor/tables/car_revision_type.dart';
import 'package:my_app_3/model/revision_model.dart';
import 'package:my_app_3/pages/car/expanding_widget.dart';
import 'package:rxdart/rxdart.dart';

class RevisionsEdit extends StatefulWidget {
  final Car car;
  final Stream<List<CarRevisionType>> ctStream;

  const RevisionsEdit(this.car, this.ctStream, {super.key});

  @override
  State<RevisionsEdit> createState() => _RevisionsEditState();
}

class _RevisionsEditState extends State<RevisionsEdit> {
  late final _revStream = RevisionModel.streamByCarId(widget.car.id!)
      .shareValue();

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
                  stream: _revStream,
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
                  Text('todo')
                ],
              )
            ),
          ),
        ]
      ]
    );
  }
}