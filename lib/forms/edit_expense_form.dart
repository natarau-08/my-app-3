
import 'dart:async';

import 'package:flutter/material.dart';

import '../controls/autocomplete_widget.dart';
import '../controls/form_separator.dart';
import '../database/database.dart';
import '../utils.dart';

class EditExpenseForm extends StatefulWidget {
  final FutureOr<void> Function(ExpenseData expenseData, List<TagData> tags) onSaving;
  final ExpenseData? expenseData;
  final String? Function(String? str)? detailsValidator;
  final Widget? child;

  const EditExpenseForm({
    super.key,
    this.expenseData,
    this.detailsValidator,
    required this.onSaving,
    this.child,
  });

  @override
  State<EditExpenseForm> createState() => _EditExpenseFormState();
}

class _EditExpenseFormState extends State<EditExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _detailsController = TextEditingController();

  TextEditingController? _tagsController;
  bool _keepTagsBetweenSaves = true;

  final List<TagData> _tags = List.empty(growable: true);
  late Future<List<TagData>> _acTags;

  @override
  void initState() {

    if(widget.expenseData != null){
      _valueController.text = widget.expenseData!.value.toString();
      if(widget.expenseData!.details != null){
        _detailsController.text = widget.expenseData!.details!;
      }

      AppDatabase.expensesDao.getTagsForExpenseId(widget.expenseData!.id)
          .then((tdl){
        if(tdl.isNotEmpty){
          setState(() {
            _tags.addAll(tdl);
          });
        }
      });
    }

    _acTags = AppDatabase.tagsDao.getAllTags();

    super.initState();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              const IntrinsicWidth(child: Text('Value:')),
              if(widget.expenseData != null) ...[
                Expanded(
                    child: Center(child: Text('Created: ${Utils.formatDateTimeLong(widget.expenseData!.createdDate)}'))
                ),
                IntrinsicWidth(child: Text('id: ${widget.expenseData!.id}')),
              ]
            ],
          ),

          TextFormField(
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true
            ),
            validator: _valueValidator,
          ),

          const FormSeparator(),

          const SizedBox(
              width: double.infinity,
              child: Text('Details:')
          ),

          TextFormField(
            controller: _detailsController,
            keyboardType: TextInputType.multiline,
            validator: widget.detailsValidator,
            maxLines: 5000,
            minLines: 1,
          ),

          const FormSeparator(),

          const SizedBox(
            width: double.infinity,
            child: Text('Tags:'),
          ),

          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              spacing: 5,
              runSpacing: 5,
              children: [
                if(_tags.isEmpty) Text('No tags added.', style: TextStyle(color: cs.tertiary),)
                else for(var t in _tags) _ExpenseTagChip(
                  t,
                  onDeleted: _onTagDeleting,
                )
              ],
            ),
          ),

          const SizedBox(height: 8.0,),

          AutocompleteWidget(
            options: _acTags,
            displayStringForOption: (item) => item.name,
            onFieldBuilding: (tec) => _tagsController = tec,
            optionBuilder: (context, item) {
              final color = item.color == null ? null : Color(item.color!);

              return InkWell(
                onTap: () => _onTagSelected(item),
                splashColor: item.color == null ? null : color,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                      children: [
                        Expanded(child: Text(item.name)),
                        if(item.color != null) Icon(Icons.circle, color: color,)
                      ]
                  ),
                ),
              );
            },
          ),

          if(widget.expenseData == null) ...[
            const FormSeparator(),
            Row(
              children: [
                const Expanded(child: Text('Keep tags between saves:')),
                Checkbox(
                    value: _keepTagsBetweenSaves,
                    onChanged: (b) => setState(() {
                      _keepTagsBetweenSaves = b ?? false;
                    })
                )
              ],
            ),
          ],

          if(widget.child != null)
            widget.child!,

          const SizedBox(height: 32,),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: _onSave,
                child: const Text('Save')
            ),
          )
        ],
      ),
    );
  }

  void _onSave() async {
    if(_formKey.currentState == null || !_formKey.currentState!.validate()) return;

    try{
      final details = _detailsController.text.trim();
      final value = double.parse(_valueController.text.trim());
      final createdDate = widget.expenseData == null ? DateTime.now() : widget.expenseData!.createdDate;

      final ed = ExpenseData(
        id: widget.expenseData == null ? 0 : widget.expenseData!.id,
        value: value,
        createdDate: createdDate,
        details: details,
      );

      await widget.onSaving.call(ed, _tags);

      if(widget.expenseData == null){
        setState(() {
          _valueController.clear();
          _detailsController.clear();
          if(!_keepTagsBetweenSaves) _tags.clear();
        });
      }

    }catch(ex){
      Utils.errorMessage('Error while saving expense: $ex');
    }
  }

  String? _valueValidator(String? value){
    if(value == null) return null;
    double? val = double.tryParse(value);
    if(val == null) return 'Value must be number';
    return null;
  }

  void _onTagDeleting(TagData t){
    setState(() {
      _tags.remove(t);
    });
  }

  void _onTagSelected(TagData tag){
    if(_tags.any((t) => t.id == tag.id)) {
      ScaffoldMessenger
          .of(context)
          .showSnackBar(
          SnackBar(content: Text('${tag.name} already added.'))
      );
    } else {
      _tags.add(tag);
    }

    setState(() {
      _tagsController?.clear();
    });
  }
}

class _ExpenseTagChip extends StatelessWidget {
  final TagData tag;
  final void Function(TagData tag)? onDeleted;

  const _ExpenseTagChip(this.tag, {this.onDeleted});

  @override
  Widget build(BuildContext context) {
    Color? c;
    TextStyle? ts;
    if(tag.color != null){
      c = Color(tag.color!);
      final l = c.computeLuminance();
      ts = TextStyle(color: l > 0.5 ? Colors.black : Colors.white);
    }

    final cs = Theme.of(context).colorScheme;

    return Chip(
      label: Text(tag.name, style: ts,),
      onDeleted: () => onDeleted?.call(tag),
      deleteIconColor: cs.error,
      backgroundColor: c,
      shadowColor: cs.shadow,
      elevation: 4,
    );
  }
}