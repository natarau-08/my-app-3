// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AppSettingsDao? _appSettingsDaoInstance;

  ExpenseDao? _expenseDaoInstance;

  TagDao? _tagDaoInstance;

  ScheduledExpenseDao? _scheduledExpenseDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `app_settings` (`key` INTEGER PRIMARY KEY AUTOINCREMENT, `value` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `expenses` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `value` REAL NOT NULL, `details` TEXT, `created_date` TEXT NOT NULL, `generated` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tags` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT, `color` TEXT, `added_time` TEXT NOT NULL, `deleted` INTEGER NOT NULL, `last_used` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `expense_tags` (`tag_id` INTEGER, `expense_id` INTEGER, PRIMARY KEY (`tag_id`, `expense_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `scheduled_expenses` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `value` REAL NOT NULL, `details` TEXT, `created_date` TEXT NOT NULL, `next_insert` TEXT NOT NULL, `repeat_pattern` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `scheduled_expense_tags` (`tag_id` INTEGER, `scheduled_expense_id` INTEGER, PRIMARY KEY (`tag_id`, `scheduled_expense_id`))');
        await database.execute(
            'CREATE UNIQUE INDEX `index_tags_name` ON `tags` (`name`)');
        await database.execute(
            'CREATE INDEX `index_expense_tags_tag_id` ON `expense_tags` (`tag_id`)');
        await database.execute(
            'CREATE INDEX `index_expense_tags_expense_id` ON `expense_tags` (`expense_id`)');
        await database.execute(
            'CREATE INDEX `index_scheduled_expense_tags_tag_id` ON `scheduled_expense_tags` (`tag_id`)');
        await database.execute(
            'CREATE INDEX `index_scheduled_expense_tags_scheduled_expense_id` ON `scheduled_expense_tags` (`scheduled_expense_id`)');
        await database.execute(
            'CREATE VIEW IF NOT EXISTS `vw_expense_list` AS select\n  e.id,\n  e.created_date,\n  e.value,\n  e.details,\n  e.generated,\n\n  count(et.tag_id) as total_tags,\n  min(t.name) as first_tag,\n\n  CAST(strftime(\'%Y\', created_date) as INTEGER) as year,\n  CAST(strftime(\'%m\', created_date) as INTEGER) as month\nfrom expenses e\nleft join expense_tags et on et.expense_id = e.id\nleft join tags t on t.id = et.tag_id\ngroup by e.id, e.created_date, e.value, e.details, e.generated\norder by e.created_date\n');
        await database.execute(
            'CREATE VIEW IF NOT EXISTS `vw_expense_months` AS select distinct\n  CAST(strftime(\'%Y\', e.created_date) as INTEGER) as year,\n  CAST(strftime(\'%m\', e.created_date) as INTEGER) as month\nfrom expenses e\norder by year, month');
        await database.execute(
            'CREATE VIEW IF NOT EXISTS `vw_expense_summary` AS select\n  ex.year,\n  ex.month,\n  CAST(SUM(ex.value) AS REAL) as total_month,\n  CAST(SUM(case when ex.value > 0 then ex.value else 0 end) AS REAL) as total_month_gain,\n  CAST(SUM(case when ex.value < 0 then ex.value else 0 end) AS REAL) as total_month_loss\nfrom (\n  select\n    cast(strftime(\'%Y\', e.created_date) as integer) as year,\n    cast(strftime(\'%m\', e.created_date) as integer) as month,\n    e.value\n  from expenses e\n) ex\ngroup by ex.year, ex.month\n');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AppSettingsDao get appSettingsDao {
    return _appSettingsDaoInstance ??=
        _$AppSettingsDao(database, changeListener);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }

  @override
  TagDao get tagDao {
    return _tagDaoInstance ??= _$TagDao(database, changeListener);
  }

  @override
  ScheduledExpenseDao get scheduledExpenseDao {
    return _scheduledExpenseDaoInstance ??=
        _$ScheduledExpenseDao(database, changeListener);
  }
}

class _$AppSettingsDao extends AppSettingsDao {
  _$AppSettingsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _appSettingsInsertionAdapter = InsertionAdapter(
            database,
            'app_settings',
            (AppSettings item) =>
                <String, Object?>{'key': item.key, 'value': item.value},
            changeListener),
        _appSettingsUpdateAdapter = UpdateAdapter(
            database,
            'app_settings',
            ['key'],
            (AppSettings item) =>
                <String, Object?>{'key': item.key, 'value': item.value},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AppSettings> _appSettingsInsertionAdapter;

  final UpdateAdapter<AppSettings> _appSettingsUpdateAdapter;

  @override
  Future<AppSettings?> findByKey(int key) async {
    return _queryAdapter.query('select * from app_settings where `key`=?1',
        mapper: (Map<String, Object?> row) => AppSettings(
            key: row['key'] as int?, value: row['value'] as String?),
        arguments: [key]);
  }

  @override
  Stream<List<AppSettings>> watchAll() {
    return _queryAdapter.queryListStream('select * from app_settings',
        mapper: (Map<String, Object?> row) => AppSettings(
            key: row['key'] as int?, value: row['value'] as String?),
        queryableName: 'app_settings',
        isView: false);
  }

  @override
  Future<int> insert(AppSettings e) {
    return _appSettingsInsertionAdapter.insertAndReturnId(
        e, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(AppSettings e) async {
    await _appSettingsUpdateAdapter.update(e, OnConflictStrategy.abort);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _expenseInsertionAdapter = InsertionAdapter(
            database,
            'expenses',
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'details': item.details,
                  'created_date': _dateTimeTc2.encode(item.createdDate),
                  'generated': item.generated
                }),
        _expenseTagInsertionAdapter = InsertionAdapter(
            database,
            'expense_tags',
            (ExpenseTag item) => <String, Object?>{
                  'tag_id': item.tagId,
                  'expense_id': item.expenseId
                }),
        _expenseUpdateAdapter = UpdateAdapter(
            database,
            'expenses',
            ['id'],
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'details': item.details,
                  'created_date': _dateTimeTc2.encode(item.createdDate),
                  'generated': item.generated
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Expense> _expenseInsertionAdapter;

  final InsertionAdapter<ExpenseTag> _expenseTagInsertionAdapter;

  final UpdateAdapter<Expense> _expenseUpdateAdapter;

  @override
  Future<List<Tag>> getTagsForExpenseId(int id) async {
    return _queryAdapter.queryList(
        'select   t.* from expense_tags et join tags t on t.id = et.tag_id where et.expense_id = ?1',
        mapper: (Map<String, Object?> row) => Tag(id: row['id'] as int?, name: row['name'] as String, description: row['description'] as String?, color: _colorTcN.decode(row['color'] as String?), added: _dateTimeTc2.decode(row['added_time'] as String), deleted: (row['deleted'] as int) != 0, lastUsed: _dateTimeTc.decode(row['last_used'] as String?)),
        arguments: [id]);
  }

  @override
  Future<int?> deleteExpenseTagForExpenseId(int eid) async {
    return _queryAdapter.query('delete from expense_tags where expense_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [eid]);
  }

  @override
  Future<List<ExpenseMonthsView>> getMonths(int limit) async {
    return _queryAdapter.queryList(
        'select * from vw_expense_months order by year desc, month desc limit ?1',
        mapper: (Map<String, Object?> row) => ExpenseMonthsView(row['year'] as int, row['month'] as int),
        arguments: [limit]);
  }

  @override
  Future<List<ExpenseListView>> getExpensesByYearAndMonth(
    int year,
    int month,
  ) async {
    return _queryAdapter.queryList(
        'select * from vw_expense_list where year=?1 and month=?2',
        mapper: (Map<String, Object?> row) => ExpenseListView(
            id: row['id'] as int,
            createdDate: _dateTimeTc2.decode(row['created_date'] as String),
            value: row['value'] as double,
            details: row['details'] as String?,
            generated: row['generated'] as int?,
            firstTag: row['first_tag'] as String?,
            totalTags: row['total_tags'] as int,
            year: row['year'] as int,
            month: row['month'] as int),
        arguments: [year, month]);
  }

  @override
  Future<ExpenseMonthSummaryView?> getMonthSummary(
    int year,
    int month,
  ) async {
    return _queryAdapter.query(
        'select * from vw_expense_summary where year=?1 and month=?2',
        mapper: (Map<String, Object?> row) => ExpenseMonthSummaryView(
            year: row['year'] as int,
            month: row['month'] as int,
            totalMonth: row['total_month'] as double,
            totalMonthGain: row['total_month_gain'] as double,
            totalMonthLoss: row['total_month_loss'] as double),
        arguments: [year, month]);
  }

  @override
  Future<Expense?> findExpenseById(int id) async {
    return _queryAdapter.query('select * from expenses where id=?1',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            value: row['value'] as double,
            details: row['details'] as String?,
            createdDate: _dateTimeTc2.decode(row['created_date'] as String),
            generated: row['generated'] as int?),
        arguments: [id]);
  }

  @override
  Future<ExpenseListView?> getViewDataForExpenseId(int id) async {
    return _queryAdapter.query('select * from vw_expense_list where id=?1',
        mapper: (Map<String, Object?> row) => ExpenseListView(
            id: row['id'] as int,
            createdDate: _dateTimeTc2.decode(row['created_date'] as String),
            value: row['value'] as double,
            details: row['details'] as String?,
            generated: row['generated'] as int?,
            firstTag: row['first_tag'] as String?,
            totalTags: row['total_tags'] as int,
            year: row['year'] as int,
            month: row['month'] as int),
        arguments: [id]);
  }

  @override
  Future<int> insert(Expense e) {
    return _expenseInsertionAdapter.insertAndReturnId(
        e, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertExpenseTagList(List<ExpenseTag> data) async {
    await _expenseTagInsertionAdapter.insertList(
        data, OnConflictStrategy.abort);
  }

  @override
  Future<void> batchInsertExpenseTags(List<ExpenseTag> rows) async {
    await _expenseTagInsertionAdapter.insertList(
        rows, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Expense e) async {
    await _expenseUpdateAdapter.update(e, OnConflictStrategy.abort);
  }

  @override
  Future<void> setExpenseTags(
    List<Tag> tags,
    int expenseId,
  ) async {
    if (database is sqflite.Transaction) {
      await super.setExpenseTags(tags, expenseId);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.expenseDao.setExpenseTags(tags, expenseId);
      });
    }
  }

  @override
  Future<void> saveExpenseWithTags(
    Expense e,
    List<Tag> tags,
  ) async {
    if (database is sqflite.Transaction) {
      await super.saveExpenseWithTags(e, tags);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.expenseDao.saveExpenseWithTags(e, tags);
      });
    }
  }
}

class _$TagDao extends TagDao {
  _$TagDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _tagInsertionAdapter = InsertionAdapter(
            database,
            'tags',
            (Tag item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'color': _colorTcN.encode(item.color),
                  'added_time': _dateTimeTc2.encode(item.added),
                  'deleted': item.deleted ? 1 : 0,
                  'last_used': _dateTimeTc.encode(item.lastUsed)
                },
            changeListener),
        _tagUpdateAdapter = UpdateAdapter(
            database,
            'tags',
            ['id'],
            (Tag item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'color': _colorTcN.encode(item.color),
                  'added_time': _dateTimeTc2.encode(item.added),
                  'deleted': item.deleted ? 1 : 0,
                  'last_used': _dateTimeTc.encode(item.lastUsed)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tag> _tagInsertionAdapter;

  final UpdateAdapter<Tag> _tagUpdateAdapter;

  @override
  Stream<List<Tag>> streamActiveTags() {
    return _queryAdapter.queryListStream('select * from tags where deleted=0',
        mapper: (Map<String, Object?> row) => Tag(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            color: _colorTcN.decode(row['color'] as String?),
            added: _dateTimeTc2.decode(row['added_time'] as String),
            deleted: (row['deleted'] as int) != 0,
            lastUsed: _dateTimeTc.decode(row['last_used'] as String?)),
        queryableName: 'tags',
        isView: false);
  }

  @override
  Stream<List<Tag>> streamDeletedTags() {
    return _queryAdapter.queryListStream('select * from tags where deleted=1',
        mapper: (Map<String, Object?> row) => Tag(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            color: _colorTcN.decode(row['color'] as String?),
            added: _dateTimeTc2.decode(row['added_time'] as String),
            deleted: (row['deleted'] as int) != 0,
            lastUsed: _dateTimeTc.decode(row['last_used'] as String?)),
        queryableName: 'tags',
        isView: false);
  }

  @override
  Future<List<Tag>> getActiveTags() async {
    return _queryAdapter.queryList(
        'select * from tags where deleted=0 order by last_used desc, name',
        mapper: (Map<String, Object?> row) => Tag(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            color: _colorTcN.decode(row['color'] as String?),
            added: _dateTimeTc2.decode(row['added_time'] as String),
            deleted: (row['deleted'] as int) != 0,
            lastUsed: _dateTimeTc.decode(row['last_used'] as String?)));
  }

  @override
  Future<void> deleteTagById(int id) async {
    await _queryAdapter
        .queryNoReturn('delete from tags where id=?1', arguments: [id]);
  }

  @override
  Future<int?> getTagExpenseCount(int id) async {
    return _queryAdapter.query(
        'select COUNT(e.id)   from expense_tags et   join expenses e on e.id = et.expense_id   where et.tag_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> getTagIdByName(String name) async {
    return _queryAdapter.query('select id from tags where name = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [name]);
  }

  @override
  Future<int> insertTag(Tag e) {
    return _tagInsertionAdapter.insertAndReturnId(e, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertList(List<Tag> tags) async {
    await _tagInsertionAdapter.insertList(tags, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Tag t) async {
    await _tagUpdateAdapter.update(t, OnConflictStrategy.abort);
  }
}

class _$ScheduledExpenseDao extends ScheduledExpenseDao {
  _$ScheduledExpenseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _scheduledExpenseInsertionAdapter = InsertionAdapter(
            database,
            'scheduled_expenses',
            (ScheduledExpense item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'details': item.details,
                  'created_date': _dateTimeTc2.encode(item.createdDate),
                  'next_insert': _dateTimeTc2.encode(item.nextInsert),
                  'repeat_pattern': item.repeatPattern
                },
            changeListener),
        _scheduledExpenseTagInsertionAdapter = InsertionAdapter(
            database,
            'scheduled_expense_tags',
            (ScheduledExpenseTag item) => <String, Object?>{
                  'tag_id': item.tagId,
                  'scheduled_expense_id': item.scheduledExpenseId
                }),
        _scheduledExpenseUpdateAdapter = UpdateAdapter(
            database,
            'scheduled_expenses',
            ['id'],
            (ScheduledExpense item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'details': item.details,
                  'created_date': _dateTimeTc2.encode(item.createdDate),
                  'next_insert': _dateTimeTc2.encode(item.nextInsert),
                  'repeat_pattern': item.repeatPattern
                },
            changeListener),
        _scheduledExpenseDeletionAdapter = DeletionAdapter(
            database,
            'scheduled_expenses',
            ['id'],
            (ScheduledExpense item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'details': item.details,
                  'created_date': _dateTimeTc2.encode(item.createdDate),
                  'next_insert': _dateTimeTc2.encode(item.nextInsert),
                  'repeat_pattern': item.repeatPattern
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ScheduledExpense> _scheduledExpenseInsertionAdapter;

  final InsertionAdapter<ScheduledExpenseTag>
      _scheduledExpenseTagInsertionAdapter;

  final UpdateAdapter<ScheduledExpense> _scheduledExpenseUpdateAdapter;

  final DeletionAdapter<ScheduledExpense> _scheduledExpenseDeletionAdapter;

  @override
  Stream<List<ScheduledExpense>> watchScheduledExpenses() {
    return _queryAdapter.queryListStream(
        'select * from scheduled_expenses order by id',
        mapper: (Map<String, Object?> row) => ScheduledExpense(
            id: row['id'] as int?,
            value: row['value'] as double,
            details: row['details'] as String?,
            createdDate: _dateTimeTc2.decode(row['created_date'] as String),
            nextInsert: _dateTimeTc2.decode(row['next_insert'] as String),
            repeatPattern: row['repeat_pattern'] as String),
        queryableName: 'scheduled_expenses',
        isView: false);
  }

  @override
  Future<List<ScheduledExpense>> getScheduledExpensesWithNextInsertSmallerThan(
      DateTime t) async {
    return _queryAdapter.queryList(
        'select * from scheduled_expenses where next_insert <= ?1',
        mapper: (Map<String, Object?> row) => ScheduledExpense(
            id: row['id'] as int?,
            value: row['value'] as double,
            details: row['details'] as String?,
            createdDate: _dateTimeTc2.decode(row['created_date'] as String),
            nextInsert: _dateTimeTc2.decode(row['next_insert'] as String),
            repeatPattern: row['repeat_pattern'] as String),
        arguments: [_dateTimeTc2.encode(t)]);
  }

  @override
  Future<List<Tag>> getTagsOfScheduledExpense(int id) async {
    return _queryAdapter.queryList(
        'select t.* from scheduled_expense_tags st join tags t on t.id = st.tag_id where st.scheduled_expense_id=?1',
        mapper: (Map<String, Object?> row) => Tag(id: row['id'] as int?, name: row['name'] as String, description: row['description'] as String?, color: _colorTcN.decode(row['color'] as String?), added: _dateTimeTc2.decode(row['added_time'] as String), deleted: (row['deleted'] as int) != 0, lastUsed: _dateTimeTc.decode(row['last_used'] as String?)),
        arguments: [id]);
  }

  @override
  Future<void> deleteTagsById(int id) async {
    await _queryAdapter.queryNoReturn(
        'delete from scheduled_expense_tags where scheduled_expense_id=?1',
        arguments: [id]);
  }

  @override
  Future<int> insert(ScheduledExpense e) {
    return _scheduledExpenseInsertionAdapter.insertAndReturnId(
        e, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTags(List<ScheduledExpenseTag> tags) async {
    await _scheduledExpenseTagInsertionAdapter.insertList(
        tags, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(ScheduledExpense e) async {
    await _scheduledExpenseUpdateAdapter.update(e, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteScheduledExpense(ScheduledExpense e) async {
    await _scheduledExpenseDeletionAdapter.delete(e);
  }

  @override
  Future<void> saveScheduledExpense(
    ScheduledExpense data,
    List<Tag> tags,
  ) async {
    if (database is sqflite.Transaction) {
      await super.saveScheduledExpense(data, tags);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.scheduledExpenseDao
            .saveScheduledExpense(data, tags);
      });
    }
  }
}

// ignore_for_file: unused_element
final _dateTimeTc = DateTimeTc();
final _dateTimeTc2 = DateTimeTc2();
final _colorTcN = ColorTcN();
