
import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/forms/tags_list_builder.dart';
import 'package:my_app_3/pages/tags_page.dart';
import 'package:my_app_3/utils.dart';
import 'package:drift/drift.dart' as drift;

import '../database/database.dart';

class DeletedTagsPage extends StatefulWidget {
  static const String title = 'Deleted tags';
  static const String route = '${TagsPage.route}/deleted';

  const DeletedTagsPage({super.key});

  @override
  State<DeletedTagsPage> createState() => _DeletedTagsPageState();
}

class _DeletedTagsPageState extends State<DeletedTagsPage> {
  late Stream<List<TagData>> _stream;

  @override
  void initState() {
    _stream = AppDatabase.tagsDao.watchAllTags(true);
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

  void _onDismissed(BuildContext context, DismissDirection dir, TagData tag) async {
    try{
      if(dir == DismissDirection.startToEnd){
        await AppDatabase.tagsDao.deleteTagById(tag.id);
      }else{
        await AppDatabase.tagsDao.updateTagById(
          tag.id,
          const TagCompanion(
            deleted: drift.Value(false)
          )
        );
      }
    }catch(ex){
      if(context.mounted){
        setState(() {
          Utils.errorMessage('Error while processing tag: $ex');
        });
      }
    }
  }

  Future<bool> _onConfirmDismiss(BuildContext context, DismissDirection dir, TagData tag) async {
    if(dir == DismissDirection.startToEnd){
      int expenseCount = await AppDatabase.tagsDao.getTagExpenseCount(tag.id);

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