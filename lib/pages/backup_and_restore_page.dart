import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/pages/settings_page.dart';
import 'package:my_app_3/utils.dart';
import 'package:path/path.dart';

import '../floor/app_database.dart';
import '../floor/tables/expense.dart';
import '../floor/tables/expense_tag.dart';
import '../floor/tables/tag.dart';

class BackupAndRestorePage extends StatefulWidget {
  static const String title = 'Backup or restore data';
  static const String route = '${SettingsPage.route}/export-to-file';

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
                onPressed: () => _importFromFile(context),
                child: const Text('Import from gzip file')),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () => _exportToFile(context),
                child: const Text('Export to gzip file'))
          ] else ...[
            const CircularProgressIndicator(),
            Text('${_message ?? 'Processing'}...'),
          ],
        ]));
  }

  void _exportToFile(BuildContext context) async {
    setState(() {
      _status = _Status.processing;
      _message = 'Exporting data to file...';
    });

    try {
      // get export file path
      final exportFilePath = await _getExportFilePath();

      if (exportFilePath == null) {
        setState(() {
          _status = _Status.idle;
        });
        return;
      }

      final exportFile = File(exportFilePath);
      final outputStream = exportFile.openWrite();

      // encode data then gzip it
      final byteDataStream =
          AppDatabase.instance.backupAndRestoreDao.streamData()
          .transform(utf8.encoder)
          .transform(gzip.encoder);

      await byteDataStream.pipe(outputStream);

      await outputStream.close();

      setState(() {
        _status = _Status.doneProcessing;
        _message = 'File exported successfully!';
      });
    } catch (ex) {
      setState(() {
        _status = _Status.error;
        _message = ex.toString();
      });
    }
  }

  Future<String?> _getExportFilePath() async {
    String? finalPath;
    final exportFileName = '${_getExportFileName()}.gzip';
    if (Platform.isAndroid) {
      finalPath = await FlutterFileDialog.saveFile(
          params: SaveFileDialogParams(fileName: exportFileName));
    } else {
      finalPath = File(Platform.resolvedExecutable).parent.path;
      finalPath = join(finalPath, exportFileName);
    }
    return finalPath;
  }

  void _importFromFile(BuildContext context) async {
    setState(() {
      _status = _Status.processing;
      _message = 'Importing data from file...';
    });

    try {
      final inputFile = await _pickFile();

      if (inputFile == null) {
        setState(() {
          _status = _Status.idle;
        });
        return;
      }

      // TODO: implement this
      throw 'not implemented';
      
    } catch (ex) {
      setState(() {
        _status = _Status.error;
        _message = ex.toString();
      });
    }
  }

  Future<File?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false, dialogTitle: 'Select file for import.');

    if (result == null || result.files.isEmpty) return null;

    return File(result.files.first.path!);
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

String _getExportFileName() {
  final df = DateFormat('yyyy-MM-dd-HHmmss');
  final part = df.format(DateTime.now());
  return '$part-my-app-3-backup';
}

enum _Status {
  idle,
  processing,
  error,
  doneProcessing,
}
