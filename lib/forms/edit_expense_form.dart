
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app_3/controls/centered_widgets.dart';

import '../controls/form_separator.dart';
import '../floor/app_database.dart';
import '../floor/tables/expense.dart';
import '../floor/tables/tag.dart';
import '../utils.dart';

class EditExpenseForm extends StatefulWidget {
  final FutureOr<void> Function(Expense expenseData, List<Tag> tags) onSaving;
  final Expense? expenseData;
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
  final _ddController = TextEditingController();

  bool _keepTagsBetweenSaves = true;

  final List<Tag> _tags = List.empty(growable: true);

  @override
  void initState() {

    if(widget.expenseData != null){
      _valueController.text = widget.expenseData!.value.toString();
      if(widget.expenseData!.details != null){
        _detailsController.text = widget.expenseData!.details!;
      }

      AppDatabase.instance.expenseDao.getTagsForExpenseId(widget.expenseData!.id!)
          .then((tdl){
        if(tdl.isNotEmpty){
          setState(() {
            _tags.addAll(tdl);
          });
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _detailsController.dispose();
    _ddController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                for(var t in _tags) _ExpenseTagChip(
                  t,
                  onDeleted: _onTagDeleting,
                ),
                OutlinedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    final tag = await showDialog<Tag>(
                        context: context,
                        builder: (context) => _TagDialog(_tags)
                    );
                    
                    if(tag != null && context.mounted) {
                      if(_tags.any((t) => t.id == tag.id)) {
                        ScaffoldMessenger
                            .of(context)
                            .showSnackBar(
                            SnackBar(content: Text('${tag.name} already added.'))
                        );
                      } else {
                        setState(() {
                          _tags.add(tag);
                        });
                      }
                    }
                  },
                  child: Text('Add tag'),
                )
              ],
            ),
          ),

          const SizedBox(height: 8.0,),

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

      final ed = Expense(
        id: widget.expenseData?.id,
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

  void _onTagDeleting(Tag t){
    setState(() {
      _tags.remove(t);
    });
  }
}

class _TagDialog extends StatefulWidget {
  final List<Tag> addedTags;
  const _TagDialog(this.addedTags);

  @override
  State<_TagDialog> createState() => _TagDialogState();
}

class _TagDialogState extends State<_TagDialog> {
  final _tagsFuture = AppDatabase.instance.tagDao.getActiveTags();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Choose tags', style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Divider(height: 0.5,),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: FutureBuilder(
              future: _tagsFuture,
              builder: (context, snapshot){
                final w = SimpleProgressIndicator.handleSnapshotForLoadingOrError(snapshot);
                if(w != null) return w;
            
                final tags = [for(final t in snapshot.data as List<Tag>)
                  if(!widget.addedTags.any((at) => at.id == t.id)) t];
            
                if(tags.isEmpty){
                  return NoDataAvailableCenteredWidget();
                }
            
                return ListView.builder(
                  itemCount: tags.length,
                  itemBuilder: (context, index){
                    final tag = tags[index];
                    return ListTile(
                      title: Text(tag.name),
                      trailing: tag.color == null ? null : Icon(Icons.circle, color: tag.color,),
                      onTap: () => Navigator.of(context).pop(tag),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseTagChip extends StatelessWidget {
  final Tag tag;
  final void Function(Tag tag)? onDeleted;

  const _ExpenseTagChip(this.tag, {this.onDeleted});

  @override
  Widget build(BuildContext context) {
    Color? c;
    TextStyle? ts;
    if(tag.color != null){
      c = tag.color!;
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