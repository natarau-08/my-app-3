
import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/forms/tags_list_builder.dart';
import 'package:my_app_3/pages/tags_page.dart';
import 'package:my_app_3/utils.dart';

import '../floor/app_database.dart';
import '../floor/tables/tag.dart';

class DeletedTagsPage extends StatefulWidget {
  static const String title = 'Deleted tags';
  static const String route = '${TagsPage.route}/deleted';

  const DeletedTagsPage({super.key});

  @override
  State<DeletedTagsPage> createState() => _DeletedTagsPageState();
}

class _DeletedTagsPageState extends State<DeletedTagsPage> {
  late Stream<List<Tag>> _stream;

  @override
  void initState() {
    _stream = AppDatabase.instance.tagDao.watchAllTags();
    _stream = Stream.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: DeletedTagsPage.title,
      child: TagsListBuilder(
        stream: _stream,
        onDismissed: _onDismissed,
        onItemTap: (_, __) {},
        onConfirmDismiss: _onConfirmDismiss,
        dismissDirection: DismissDirection.horizontal
      )
    );
  }

  void _onDismissed(BuildContext context, DismissDirection dir, Tag tag) async {
    try{
      if(dir == DismissDirection.startToEnd){
        await AppDatabase.instance.tagDao.deleteTagById(tag.id!);
      }else{
        tag.deleted = false;
        await AppDatabase.instance.tagDao.update(tag);
      }
    }catch(ex){
      if(context.mounted){
        setState(() {
          Utils.errorMessage('Error while processing tag: $ex');
        });
      }
    }
  }

  Future<bool> _onConfirmDismiss(BuildContext context, DismissDirection dir, Tag tag) async {
    if(dir == DismissDirection.startToEnd){
      int expenseCount = await AppDatabase.instance.tagDao.getTagExpenseCount(tag.id!) ?? 0;

      if(context.mounted){
        if(expenseCount > 0){
          Utils.warningMessage('Cannot permanently delete tag "${tag.name}" because it is used in $expenseCount expenses.');
        }else{
          return await Utils.confirm(context, 'Are you sure?', 'Permanently delete tag "${tag.name}"?');
        }
      }

      return false;
    }else{
      return await Utils.confirm(context, 'Are you sure?', 'Restore tag "${tag.name}"?');
    }
  }
}