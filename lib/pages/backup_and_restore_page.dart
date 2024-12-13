
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/controls/centered_widgets.dart';
import 'package:my_app_3/database/database.dart';
import 'package:my_app_3/pages/settings_page.dart';
import 'package:my_app_3/utils.dart';
import 'package:path/path.dart';

import '../constants.dart';

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

  static const _beginTags = '--begin-tags';
  static const _beginExpenses = '--begin-expenses';
  static const _beginExpenseTags = '--begin-expense-tags';
  static const _beginScheduledExpenses = '--begin-scheduled-expenses';
  static const _beginScheduledExpenseTags = '--begin-scheduled-expense-tags';
  static const _lineTerm = '\n';

  static const _tagCount = 'tc';
  static const _expenseCount = 'ec';
  static const _expenseTagCount = 'etc';
  static const _scheduledExpenseCount = 'sec';
  static const _scheduledExpenseTagCount = 'setc';
  static const _version = 'v';

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: BackupAndRestorePage.title,
      child: SimpleVerticalCenteredWidget(
        children: [
          if(_status != _Status.processing) ...[
            if(_status == _Status.doneProcessing) ...[
              const Icon(Icons.verified, size: 75, color: Colors.green,),
              Text(_message ?? 'Processing done!'),
              const SizedBox(height: 8,),
            ],

            if(_status == _Status.error) ...[
              const Icon(Icons.error, size: 75, color: Colors.red,),
              Text(_message ?? 'error'),
              const SizedBox(height: 8,),
            ],

            ElevatedButton(
              onPressed: () => _importJsonFromMyApp2(context),
              child: const Text('Import from my app 2 JSON')
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () => _importFromFile(context),
              child: const Text('Import from gzip file')
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () => _exportToFile(context),
              child: const Text('Export to gzip file')
            )
          ]
          else ...[
            const CircularProgressIndicator(),
            Text('${_message ?? 'Processing'}...'),
          ],
        ]
      )
    );
  }

  // <editor-fold desc="Export to file" defaultstate="collapsed">
  void _exportToFile(BuildContext context) async {
    setState(() {
      _status = _Status.processing;
      _message = 'Exporting data to file...';
    });

    try{
      // get export file path
      final exportFilePath = await _getExportFilePath();

      if(exportFilePath == null){
        setState(() {
          _status = _Status.idle;
        });
        return;
      }

      final exportFile = File(exportFilePath);
      final outputStream = exportFile.openWrite();

      // encode data then gzip it
      final byteDataStream = _streamData().transform(utf8.encoder).transform(gzip.encoder); 

      await byteDataStream.pipe(outputStream);

      await outputStream.close();

      setState(() {
        _status = _Status.doneProcessing;
        _message = 'File exported successfully!';
      });
    }catch(ex){
      setState(() {
        _status = _Status.error;
        _message = ex.toString();
      });
    }
  }

  Future<String?> _getExportFilePath() async {
    String? finalPath;
    final exportFileName = '${_getExportFileName()}.gzip';
    if(Platform.isAndroid){
      finalPath = await FlutterFileDialog.saveFile(params: SaveFileDialogParams(
          fileName: exportFileName
      ));
    }else{
      finalPath = File(Platform.resolvedExecutable).parent.path;
      finalPath = join(finalPath, exportFileName);
    }
    return finalPath;
  }

  Stream<String> _streamData() async* {
    final tagCount = await AppDatabase.tagsDao.getAllTagsCount();
    final expenseCount = await AppDatabase.expensesDao.getExpenseCount();
    final expenseTagCount = await AppDatabase.expensesDao.getAllExpenseTagCount();
    final scheduledExpenseCount = await AppDatabase.scheduledExpensesDao.getAllScheduledExpenseCount();
    final scheduledExpenseTagCount = await AppDatabase.scheduledExpensesDao.getAllScheduledExpenseTagCount();

    yield jsonEncode({
      _version: Constants.version,
      _tagCount: tagCount,
      _expenseCount: expenseCount,
      _expenseTagCount: expenseTagCount,
      _scheduledExpenseCount: scheduledExpenseCount,
      _scheduledExpenseTagCount: scheduledExpenseTagCount
    });

    yield _lineTerm;

    const int batchSize = 25;
    int lastId = -1;

    int batches = (tagCount / batchSize).floor() + 1;
    yield _beginTags;
    yield _lineTerm;
    for(int i=0;i<batches;i++){
      final data = await AppDatabase.tagsDao.getBatch(batchSize, lastId);
      for(var x in data){
        lastId = x.id;
        yield x.toJsonString();
        yield _lineTerm;
      }
    }

    lastId = -1;
    batches = (expenseCount / batchSize).floor() + 1;
    yield _beginExpenses;
    yield _lineTerm;
    for(int i=0;i<batches;i++){
      final data = await AppDatabase.expensesDao.getExpenseBatch(batchSize, lastId);
      for(var x in data){
        lastId = x.id;
        yield x.toJsonString();
        yield _lineTerm;
      }
    }

    lastId = -1;
    // batches = (expenseCount / batchSize).floor() + 1;
    yield _beginExpenseTags;
    yield _lineTerm;
    for(int i=0;i<batches;i++){
      final data = await AppDatabase.expensesDao.getExpenseTagBatch(batchSize, lastId);
      for(var x in data.$1){
        yield x.toJsonString();
        yield _lineTerm;
      }
      lastId = data.$2;
    }

    lastId = -1;
    batches = scheduledExpenseCount ~/ batchSize + 1;
    yield _beginScheduledExpenses;
    yield _lineTerm;
    for(int i=0;i<batches;i++){
      final data = await AppDatabase.scheduledExpensesDao.getScheduledExpenseBatch(batchSize, lastId);
      for(var x in data){
        lastId = x.id;
        yield x.toJsonString();
        yield _lineTerm;
      }
    }

    lastId = -1;
    yield _beginScheduledExpenseTags;
    yield _lineTerm;
    for(int i=0;i<batches;i++){
      final data = await AppDatabase.scheduledExpensesDao.getScheduledExpenseTagBatch(batchSize, lastId);
      for(var x in data.$1){
        yield x.toJsonString();
        yield _lineTerm;
      }
      lastId = data.$2;
    }
  }
  // </editor-fold>

  // <editor-fold desc="Import file" defaultstate="collapsed">
  void _importFromFile(BuildContext context) async {
    setState(() {
      _status = _Status.processing;
      _message = 'Importing data from file...';
    });

    try{
      final inputFile = await _pickFile();

      if(inputFile == null){
        setState(() {
          _status = _Status.idle;
        });
        return;
      }

      final inputStream = inputFile.openRead().transform(gzip.decoder);
      final lineStream = inputStream.transform(utf8.decoder).transform(const LineSplitter());

      final streamIterator = StreamIterator(lineStream);

      try{

        if(!await streamIterator.moveNext()) throw 'Input file is empty.';

        Map<String, dynamic> json = jsonDecode(streamIterator.current);
        dynamic token = json[_version];
        if(token == null || token is! String) throw 'Header does not contain a version string.';

        if(!context.mounted || token != Constants.version
          && !await Utils.confirm(context, 'Warning!', 'File version differs from current version. File version: $token, App version: ${Constants.version}. Continue import?')) {
          await streamIterator.cancel();
          return;
        }

        int tagCount = json[_tagCount] as int;
        int expenseCount = json[_expenseCount] as int;
        int expenseTagsCount = json[_expenseTagCount] as int;
        int scheduledExpenseCount = json[_scheduledExpenseCount] as int;
        int scheduledExpenseTagCount = json[_scheduledExpenseTagCount] as int;

        if(!context.mounted || !await Utils.confirm(context, 'Are you sure?', 'This operation will wipe the database. New entries: $tagCount tags and $expenseCount expenses. Continue?')){
          await streamIterator.cancel();
          return;
        }

        await AppDatabase.instance.nukeDatabase();

        await streamIterator.moveNext();
        if(streamIterator.current != _beginTags) throw 'Line ${streamIterator.current} was supposed to be $_beginTags';

        setState(() {
          _message = 'Importing tags';
        });

        /// holds old id to new id
        final tagsMap = <int, int>{};
        for(int i=0;i<tagCount;i++){
          await streamIterator.moveNext();
          final tagData = TagData.fromJson(jsonDecode(streamIterator.current));
          final comp = tagData.copyWith(id: null).toCompanion(true);
          final int id = await AppDatabase.tagsDao.insertTag(comp);

          tagsMap[tagData.id] = id;
        }

        await streamIterator.moveNext();
        if(streamIterator.current != _beginExpenses) throw 'Line ${streamIterator.current} was supposed to be $_beginExpenses';

        setState(() {
          _message = 'Importing expenses';
        });

        final expenseMap = <int, int>{};
        for(int i=0;i<expenseCount;i++){
          await streamIterator.moveNext();
          final expData = ExpenseData.fromJson(jsonDecode(streamIterator.current));
          final comp = expData.copyWith(id: null).toCompanion(true);
          final id = await AppDatabase.expensesDao.saveExpense(comp);

          expenseMap[expData.id] = id;
        }

        await streamIterator.moveNext();
        if(streamIterator.current != _beginExpenseTags) throw 'Line ${streamIterator.current} was supposed to be $_beginExpenseTags';

        setState(() {
          _message = 'Importing expense tags';
        });

        for(int i=0;i<expenseTagsCount;i++){
          await streamIterator.moveNext();
          final etData = ExpenseTagData.fromJson(jsonDecode(streamIterator.current));
          final comp = etData.copyWith(
            expenseId: expenseMap[etData.expenseId],
            tagId: tagsMap[etData.tagId]
          ).toCompanion(true);

          await AppDatabase.expensesDao.insertExpenseTag(comp);
        }

        await streamIterator.moveNext();
        if(streamIterator.current != _beginScheduledExpenses) throw 'Line ${streamIterator.current} was supposed to be $_beginScheduledExpenses';

        setState(() {
          _message = 'Importing scheduled expenses';
        });

        final scheduledMap = <int,int>{};
        for(int i=0;i<scheduledExpenseCount;i++){
          await streamIterator.moveNext();
          final data = ScheduledExpenseData.fromJson(jsonDecode(streamIterator.current));
          final comp = data.copyWith(id: null).toCompanion(true);
          final id = await AppDatabase.scheduledExpensesDao.saveScheduledExpense(comp);
          scheduledMap[data.id] = id;
        }

        setState(() {
          _message = 'Importing scheduled expenses tags';
        });

        await streamIterator.moveNext();
        if(streamIterator.current != _beginScheduledExpenseTags){
          throw 'Line ${streamIterator.current} was expected to be $_beginScheduledExpenseTags';
        }

        for(int i=0;i<scheduledExpenseTagCount;i++){
          await streamIterator.moveNext();
          final data = ScheduledExpenseTagData.fromJson(jsonDecode(streamIterator.current));
          final schExpId = scheduledMap[data.scheduledExpenseId] as int;
          final tagId = tagsMap[data.tagId] as int;
          await AppDatabase.scheduledExpensesDao.insertTag(schExpId, tagId);
        }

        setState(() {
          _status = _Status.doneProcessing;
          _message = 'File imported successfully.';
        });

        await streamIterator.cancel();
      }catch(e){
        await streamIterator.cancel();
        rethrow;
      }

    }catch(ex){
      setState(() {
        _status = _Status.error;
        _message = ex.toString();
      });
    }
  }

  Future<File?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      dialogTitle: 'Select file for import.'
    );
    
    if(result == null || result.files.isEmpty) return null;

    return File(result.files.first.path!);
  }
  // </editor-fold>

  // <editor-fold desc="JSON import from My app 2" defaultstate="collapsed">
  void _importJsonFromMyApp2(BuildContext context) async {
    if(!await Utils.confirm(
      context,
      'Are you sure?',
      'Importing a JSON from My App 2 will delete everything in the current database.')) return;

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      dialogTitle: 'Pick My App 2 JSON File',
      type: FileType.any
    );

    setState(() {
      _status = _Status.processing;
      _message = 'Importing from JSON file';
    });

    try{
      if(result == null || result.files.isEmpty){
        throw 'No file chose. Operation canceled.';
      }
      
      final filePath = result.files.first.path;
      if(filePath == null) throw Exception('Failed to retrieve file path.');

      final file = File(filePath);
      final content = await file.readAsString();

      setState(() {
        _message = 'Decoding json file...';
      });

      Map<String, dynamic> json = jsonDecode(content);

      setState(() {
        _message = 'Nuking database...';
      });

      final d = await AppDatabase.instance.nukeDatabase();
      if(d > 0){
        Utils.infoMessage('Deleted $d total entries in the database!');
      }

      setState(() {
        _message = 'Saving tags...';
      });

      // tags
      final tagMap = <int, int>{};
      final List<dynamic> categories = json['expenseCategories'] ?? (throw Exception('Invalid JSON: expected key "expenseCategories".'));
      for(Map<String, dynamic> cat in categories){
        final id = await AppDatabase.tagsDao.insertTag(TagCompanion(
          added: drift.Value(DateTime.now()),
          color: const drift.Value.absent(),
          description: cat['description'] == null ? const drift.Value.absent() : drift.Value(cat['description'] as String),
          name: cat['name'] == null
            ? (throw Exception('Invalid JSON: expected key "name" in "expenseCategories" array child.'))
            : drift.Value(cat['name'] as String),
          deleted: drift.Value(!(cat['visible'] as bool))
        ));
        
        final oid = cat['uid'] as int;
        tagMap[oid] = id;
      }

      setState(() {
        _message = 'Saving expenses...';
      });

      // expenses
      final expenseTags = <ExpenseTagCompanion>[];
      final List<dynamic> exps = json['expenses'] ?? (throw Exception('Invalid JSON: expected key "expenses".'));
      for(Map<String, dynamic> e in exps){
        final id = await AppDatabase.expensesDao.saveExpense(ExpenseCompanion(
          createdDate: e['dateAdded'] == null
            ? (throw Exception('Invalid JSON: expected key "dateAdded" in "expenses" array child.'))
            : drift.Value(DateTime.parse(e['dateAdded'] as String)),

            details: e['details'] == null ? const drift.Value.absent() : drift.Value(e['details'] as String),

            value: e['value'] == null
              ? (throw Exception('Invalid JSON: expected key "value" in "expenses" array child.'))
              : drift.Value(e['value'] as double),

            generated: e['futureExpenseId'] == null ? const drift.Value.absent() : drift.Value(e['futureExpenseId'] as int)
        ));

        final catId = e['categoryUid'] as int?;
        if(catId != null){
          int tagId = tagMap[catId] ?? (throw Exception('Could not find the category with id=$catId'));
          expenseTags.add(ExpenseTagCompanion(
            tagId: drift.Value(tagId),
            expenseId: drift.Value(id)
          ));
        }
      }

      setState(() {
        _message = 'Saving expense tags...';
      });

      await AppDatabase.expensesDao.batchInsertExpenseTags(expenseTags);

      setState(() {
        _message = 'JSON file imported successfully!';
        _status = _Status.doneProcessing;
      });

      Utils.warningMessage('Future expenses where not imported. This is by design.');
    }catch(ex){
      setState(() {
        _message = ex.toString();
        _status = ex is String ? _Status.doneProcessing : _Status.error;
      });
    }
  }
  // </editor-fold>
}

// <editor-fold desc="Utils" defaultstate="collapsed">
String _getExportFileName(){
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
// </editor-fold>