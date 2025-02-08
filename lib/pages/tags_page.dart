import 'package:flutter/material.dart';
import 'package:my_app_3/app_main_page.dart';
import 'package:my_app_3/floor/tables/tag.dart';
import 'package:my_app_3/forms/tags_list_builder.dart';
import 'package:my_app_3/pages/deleted_tags_page.dart';
import 'package:my_app_3/pages/edit_tag_page.dart';
import 'package:my_app_3/utils.dart';

import '../floor/app_database.dart';

class TagsPage extends StatefulWidget {
  static const String title = 'Tags';
  static const String route = '/tags';

  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  late Stream<List<Tag>> _stream;

  @override
  void initState() {
    _stream = AppDatabase.instance.tagDao.streamActiveTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppMainPage(
      title: TagsPage.title,
      actions: [
        IconButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed(DeletedTagsPage.route);
          },
          icon: const Icon(Icons.delete)
        ),
        IconButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed(EditTagPage.route);
          },
          icon: const Icon(Icons.add)
        )
      ],
      body: TagsListBuilder(
        stream: _stream,
        dismissDirection: DismissDirection.startToEnd,
        onDismissed: _onDismissed,
        onItemTap: _onItemTap,
        onConfirmDismiss: (context, dir, tag) => Utils.confirm(context, 'Are you sure?', 'Move tag "${tag.name}" to trash?'),
      )
    );
  }

  void _onDismissed(BuildContext context, _, Tag tag) async {
    try{
        tag.deleted = true;
        await AppDatabase.instance.tagDao.update(tag);

        if(context.mounted){
          Utils.infoMessage('Tag "${tag.name}" moved to trash.');
        }
    } catch(ex){
      if(context.mounted){
        setState(() {
          Utils.errorMessage('Error while deleting tag: $ex');
        });
      }
    }
    return;
  }

  void _onItemTap(BuildContext context, Tag tag){
    Navigator.of(context).pushNamed(EditTagPage.route, arguments: tag);
  }
}