
import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/constants.dart';
import 'package:my_app_3/controls/form_separator.dart';
import 'package:my_app_3/controls/save_cancel_buttons.dart';
import 'package:my_app_3/floor/app_database.dart';
import 'package:my_app_3/floor/tables/tag_tracking.dart';
import 'package:my_app_3/utils.dart';

import '../../floor/tables/tag.dart';

class ReportExpenseTagTrackingEdit extends StatefulWidget{
  static const route = '/rep/ett/edit';

  const ReportExpenseTagTrackingEdit({super.key});

  @override
  State<ReportExpenseTagTrackingEdit> createState() => _ReportExpenseTagTrackingEditState();
}

class _ReportExpenseTagTrackingEditState extends State<ReportExpenseTagTrackingEdit> {
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();
  final _startingDateController = TextEditingController();
  final _tags = AppDatabase.instance.tagDao.getActiveTags();
  final _formKey = GlobalKey<FormState>();

  TagTracking? _entity;
  bool _initialized = false;
  DateTime? _startingDate;
  int? _tagId;
  bool _pinned = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _detailsController.dispose();
    _startingDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!_initialized && ModalRoute.of(context)?.settings.arguments is TagTracking){
      final tagTracking = ModalRoute.of(context)!.settings.arguments as TagTracking;

      _nameController.text = tagTracking.name;
      _detailsController.text = tagTracking.description;
      _startingDate = tagTracking.startingDate;
      _startingDateController.text = Utils.formatDate(_startingDate!);
      _tagId = tagTracking.tagId;
      _pinned = tagTracking.pinned;

      _initialized = true;
      _entity = tagTracking;
    }

    return AppSecondaryPage(
      title: 'Edit expense tag tracking',
      child: Padding(
        padding: const EdgeInsets.all(Constants.pagePadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Name')
                ),
                controller: _nameController,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Name is required';
                  }
                  return null;
                },
              ),

              FormSeparator(),

              TextField(
                decoration: InputDecoration(
                  label: Text('Details')
                ),
                controller: _detailsController,
              ),

              FormSeparator(),

              TextFormField(
                readOnly: true,
                controller: _startingDateController,
                decoration: InputDecoration(
                  label: Text('Starting date'),
                  suffixIcon: Icon(Icons.calendar_today, )
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100)
                  );

                  if (date != null) {
                    _startingDate = date;
                    _startingDateController.text = Utils.formatDate(_startingDate!);
                  }
                },
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Starting date is required';
                  }
                  return null;
                },
              ),

              FormSeparator(),

              FutureBuilder(
                future: _tags,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final tags = snapshot.data as List<Tag>;

                  return DropdownMenu(
                    label: Text('Tag'),
                    enableFilter: false,
                    enableSearch: false,
                    expandedInsets: EdgeInsets.zero,
                    initialSelection: tags.where((x) => x.id == _tagId).firstOrNull,
                    onSelected: (value) {
                      _tagId = value?.id;
                    },
                    dropdownMenuEntries: tags.map((tag) => DropdownMenuEntry<Tag>(
                      value: tag,
                      label: tag.name,
                      trailingIcon: tag.color == null ? null : Icon(Icons.circle, color: tag.color!),
                    )).toList(),
                  );
                },
              ),

              FormSeparator(),

              ListTile(
                title: Text('Pinned'),
                trailing: Switch(
                  value: _pinned,
                  onChanged: (value) {
                    setState(() {
                      _pinned = value;
                    });
                  }
                )
              ),

              FormSeparator(),

              SaveCancelButtons(
                onSave: () async {
                  if(!_formKey.currentState!.validate()){
                    return;
                  }

                  if(_tagId == null){
                    Utils.errorMessage('Tag is required');
                    return;
                  }

                  try{
                    final entity = TagTracking(
                      id: _entity?.id,
                      tagId: _tagId!,
                      startingDate: _startingDate!,
                      pinned: _pinned,
                      name: _nameController.text.trim(),
                      description: _detailsController.text.trim(),
                      createdDate: _entity?.createdDate ?? DateTime.now()
                    );

                    if(entity.id == null){
                      entity.id = await AppDatabase.instance.tagTrackingDao.insert(entity);
                    } else {
                      await AppDatabase.instance.tagTrackingDao.update(entity);
                    }

                    if(context.mounted){
                      Utils.successMessage('Tag tracking saved.');
                      Navigator.pop(context, entity);
                    }
                  }catch(e){
                    if(mounted){
                      Utils.errorMessage(e.toString());
                    }
                  }
                },
                onCancel: (){
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ),
      )
    );
  }
}