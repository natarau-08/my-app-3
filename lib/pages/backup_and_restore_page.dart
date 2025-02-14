import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/pages/settings_page.dart';
import 'package:my_app_3/utils.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../floor/app_database.dart';
import '../floor/tables/expense.dart';
import '../floor/tables/expense_tag.dart';
import '../floor/tables/tag.dart';

class BackupAndRestorePage extends StatefulWidget {
  static const String title = 'Backup or restore data';
  static const String route = '${SettingsPage.route}/export-to-file';
  static const methodChannel = MethodChannel('backup');

  const BackupAndRestorePage({super.key});

  @override
  State<BackupAndRestorePage> createState() => _BackupAndRestorePageState();
}

class _BackupAndRestorePageState extends State<BackupAndRestorePage> {
  _Status _status = _Status.idle;
  String? _message;

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
        title: BackupAndRestorePage.title,
        child: SimpleVerticalCenteredWidget(children: [
          if (_status != _Status.processing) ...[
            if (_status == _Status.doneProcessing) ...[
              const Icon(
                Icons.verified,
                size: 75,
                color: Colors.green,
              ),
              Text(_message ?? 'Processing done!'),
              const SizedBox(
                height: 8,
              ),
            ],
            if (_status == _Status.error) ...[
              const Icon(
                Icons.error,
                size: 75,
                color: Colors.red,
              ),
              Text(_message ?? 'error'),
              const SizedBox(
                height: 8,
              ),
            ],
            ElevatedButton(
                onPressed: () => _importJsonFromMyApp2(context),
                child: const Text('Import from my app 2 JSON')),
            
            const SizedBox(
              height: 8,
            ),

            ElevatedButton(
              onPressed: () { _backupDatabase(context); },
              child: const Text('Backup database')
            ),

            const SizedBox(
              height: 8,
            ),

            ElevatedButton(
              onPressed: () { _restoreDatabase(context); },
              child: const Text('Restore database')
            ),
          ] else ...[
            const CircularProgressIndicator(),
            Text('${_message ?? 'Processing'}...'),
          ],
        ]));
  }

  void _backupDatabase(BuildContext context) async {
    setState(() {
      _status = _Status.processing;
      _message = 'Backup database in progress...';
    });

    try{
      // export path
      final df = DateFormat('yyyy-MM-dd-HHmmss');
      final part = df.format(DateTime.now());
      final exportFileName = 'my-app-backup-$part.zip';
      final String? path = await BackupAndRestorePage.methodChannel.invokeMethod('saveFile', exportFileName);

      throw 'Not implemented';

      // if(Platform.isAndroid){
      //   if (!await Permission.storage.request().isGranted && !await Permission.manageExternalStorage.request().isGranted) {
      //     setState(() {
      //       _message = 'Permission denied. Operation canceled.';
      //       _status = _Status.error;
      //     });
      //     return;
      //   }
      // }

      // if(Platform.isAndroid){
        // path = await FilePicker.platform.saveFile(
        //   dialogTitle: 'Save backup file',
        //   fileName: exportFileName
        // );
      // }else{
      //   path = File(Platform.resolvedExecutable).parent.path;
      //   path = join(path, exportFileName);
      // }

      // if(path == null){
      //   setState(() {
      //     _message = 'No file selected. Operation canceled.';
      //     _status = _Status.idle;
      //   });
      //   return;
      // }

      // final dbFile = File(AppDatabase.dbPath);
      // final bytes = await dbFile.readAsBytes();

      // final archive = Archive()
      //   ..addFile(ArchiveFile(basename(AppDatabase.dbPath), bytes.length, bytes));

      // final zipBytes = ZipEncoder().encode(archive);

      // final zipFile = File(path);
      // await zipFile.writeAsBytes(zipBytes);

      // setState(() {
      //   _message = 'Database backup completed!';
      //   _status = _Status.doneProcessing;
      // });

    }catch(ex){
      setState(() {
        _message = ex.toString();
        _status = _Status.error;
      });
    }
  }

  void _restoreDatabase(BuildContext context) async {
    setState(() {
      _status = _Status.processing;
      _message = 'Restore database in progress...';
    });

    try{
      throw 'Not implemented';
    }catch(ex){
      setState(() {
        _message = ex.toString();
        _status = _Status.error;
      });
    }
  }

  void _importJsonFromMyApp2(BuildContext context) async {
    if (!await Utils.confirm(context, 'Are you sure?',
        'Importing a JSON from My App 2 will delete everything in the current database.')) {
      return;
    }

    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        dialogTitle: 'Pick My App 2 JSON File',
        type: FileType.any);

    setState(() {
      _status = _Status.processing;
      _message = 'Importing from JSON file';
    });

    try {
      if (result == null || result.files.isEmpty) {
        throw 'No file chose. Operation canceled.';
      }

      final filePath = result.files.first.path;
      if (filePath == null) throw Exception('Failed to retrieve file path.');

      final file = File(filePath);
      final content = await file.readAsString();

      setState(() {
        _message = 'Decoding json file...';
      });

      Map<String, dynamic> json = jsonDecode(content);

      setState(() {
        _message = 'Nuking database...';
      });

      await AppDatabase.nukeDatabase();

      setState(() {
        _message = 'Saving tags...';
      });

      // tags
      final tagMap = <int, int>{};
      final List<dynamic> categories = json['expenseCategories'] ??
          (throw Exception('Invalid JSON: expected key "expenseCategories".'));
      for (Map<String, dynamic> cat in categories) {
        final id = await AppDatabase.instance.tagDao.insertTag(Tag(
            added: DateTime.now(),
            description: cat['description'] as String?,
            name: cat['name'] == null
                ? (throw Exception(
                    'Invalid JSON: expected key "name" in "expenseCategories" array child.'))
                : cat['name'] as String,
            deleted: !(cat['visible'] as bool)));

        final oid = cat['uid'] as int;
        tagMap[oid] = id;
      }

      setState(() {
        _message = 'Saving expenses...';
      });

      // expenses
      final expenseTags = <ExpenseTag>[];
      final List<dynamic> exps = json['expenses'] ??
          (throw Exception('Invalid JSON: expected key "expenses".'));
      for (Map<String, dynamic> e in exps) {
        final id = await AppDatabase.instance.expenseDao.saveExpense(Expense(
            createdDate: e['dateAdded'] == null
                ? (throw Exception(
                    'Invalid JSON: expected key "dateAdded" in "expenses" array child.'))
                : DateTime.parse(e['dateAdded'] as String),
            details: e['details'] as String?,
            value: e['value'] == null
                ? (throw Exception(
                    'Invalid JSON: expected key "value" in "expenses" array child.'))
                : e['value'] as double,
            generated: e['futureExpenseId'] as int?));

        final catId = e['categoryUid'] as int?;
        if (catId != null) {
          int tagId = tagMap[catId] ??
              (throw Exception('Could not find the category with id=$catId'));
          expenseTags.add(ExpenseTag(tagId: tagId, expenseId: id));
        }
      }

      setState(() {
        _message = 'Saving expense tags...';
      });

      await AppDatabase.instance.expenseDao.batchInsertExpenseTags(expenseTags);

      setState(() {
        _message = 'JSON file imported successfully!';
        _status = _Status.doneProcessing;
      });

      Utils.warningMessage(
          'Future expenses where not imported. This is intended.');
    } catch (ex) {
      setState(() {
        _message = ex.toString();
        _status = ex is String ? _Status.doneProcessing : _Status.error;
      });
    }
  }
}

enum _Status {
  idle,
  processing,
  error,
  doneProcessing,
}
