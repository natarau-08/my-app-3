
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/controls/form_separator.dart';
import 'package:my_app_3/controls/save_cancel_buttons.dart';
import 'package:my_app_3/database/database.dart';
import 'package:my_app_3/utils.dart';

import '../constants.dart';

class EditTagPage extends StatefulWidget {
  static const String route = '/tags/edit-tag';

  const EditTagPage({super.key});

  @override
  State<EditTagPage> createState() => _EditTagPageState();
}

class _EditTagPageState extends State<EditTagPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  // color picker animation
  bool _showColorPicker = false;

  TagData? _tag;
  String? _title;
  Color _tagColor = Colors.transparent;

  String? _dbValidationError;

  @override
  void dispose(){
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_title == null){
      _tag = ModalRoute.of(context)?.settings.arguments as TagData?;
      _title = _tag == null ? 'Create new tag' : 'Edit tag "${_tag!.name}" #${_tag!.id}';
      if(_tag != null){
        _nameController.text = _tag!.name;
        if(_tag!.description != null) _descController.text = _tag!.description!;
        if(_tag!.color != null) {
          _showColorPicker = true;
          _tagColor = Color(_tag!.color!);
        }
      }
    }
    
    final String title = _title!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if(didPop) return;
        Navigator.pop(context);
      },
      child: AppSecondaryPage(
        title: title,
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.save)
          )
        ],
        child: Padding(
          padding: EdgeInsets.all(Constants.pagePadding),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(flex: 2,child: Text('Name'),),
                      if(_tag != null) ...[
                        Expanded(flex: 4, child: Text('Added: ${Utils.formatDateTimeLong(_tag!.added)}')),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text('id: ${_tag!.id}')
                          )
                        )
                      ],
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _nameController,
                      validator: _nameValidator,
                    ),
                  ),
                
                  const FormSeparator(),
                
                  const SizedBox(
                    width: double.infinity,
                    child: Text('Description'),
                  ),
                  TextField(
                    controller: _descController,
                    maxLines: 5000,
                    minLines: 1,
                  ),
                
                  const FormSeparator(),
                
                  Row(
                    children: [
                      const Expanded(child: Text('Color')),
                      Switch(
                        value: _showColorPicker,
                        onChanged: (b) => setState(() {
                          _showColorPicker = b;
                        })
                      )
                    ],
                  ),
                  
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: double.infinity,
                    height: _showColorPicker ? 480 : 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ColorPicker(
                            portraitOnly: true,
                            pickerColor: _tagColor,
                            onColorChanged: (c) => _tagColor = c
                          ),
                        ),
                      ),
                    ),
                  ),
                
                  const FormSeparator(),
                
                  SaveCancelButtons(
                    onSave: _save,
                    onCancel: () async {
                      Navigator.of(context).pop();
                    }
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  void _save() async {
    final AppDatabase db = AppDatabase.instance;
    final String tagName = _nameController.text.trim();
    final String tagDesc = _descController.text.trim();
    int? color = _showColorPicker ? _tagColor.value : null;

    _dbValidationError = null;
    if(_tag == null){
      final e = await (
        db.select(db.tag)
          ..where((x) => x.name.equals(tagName))
      ).getSingleOrNull() != null;

      if(e){
        _dbValidationError = 'There already exists a tag with this name.';
      }
    }

    if(_formKey.currentState == null || !_formKey.currentState!.validate()) return;

    // saving data
    try{
      final c = TagCompanion(
        id: _tag == null ? const drift.Value.absent() : drift.Value(_tag!.id),
        name: drift.Value(tagName),
        description: drift.Value(tagDesc.isEmpty ? null : tagDesc),
        color: drift.Value(color),
        added: _tag == null ? drift.Value(DateTime.now()) : drift.Value(_tag!.added),
        deleted: const drift.Value(false)
      );

      if(_tag != null){
        await AppDatabase.tagsDao.updateTag(c);
      }else{
        await AppDatabase.tagsDao.insertTag(c);
      }

      Utils.infoMessage('$tagName tag saved.');

      if(context.mounted){
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }catch(ex){
      if(context.mounted){
        // ignore: use_build_context_synchronously
        Utils.errorMessage(ex.toString());
      }
    }
  }

  String? _nameValidator(String? value) {
    if(value == null || value.isEmpty) return 'Name cannot be empty.';
    return _dbValidationError;
  }
}