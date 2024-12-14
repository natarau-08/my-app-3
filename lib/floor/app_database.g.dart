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
            'CREATE TABLE IF NOT EXISTS `tags` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT, `color` INTEGER, `added_time` TEXT NOT NULL, `deleted` INTEGER NOT NULL)');
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
            'CREATE VIEW IF NOT EXISTS `vw_expense_list` AS select\n  e.id,\n  e.created_date,\n  e.value,\n  e.details,\n  e.generated,\n\n  count(et.tag_id) as total_tags,\n  min(t.name) as first_tag\nfrom expenses e\njoin expense_tags et on et.expense_id = e.id\njoin tags t on t.id = et.tag_id\ngroup by e.id, e.created_date, e.value, e.details, e.generated\norder by e.created_date\n');
        await database.execute(
            'CREATE VIEW IF NOT EXISTS `vw_expense_months_view` AS select distinct\n  strftime(\'%Y\', e.created_date) as year,\n  strftime(\'%M\', e.created_date) as month\nfrom expenses e\norder by year, month');
        await database.execute(
            'CREATE VIEW IF NOT EXISTS `vw_expense_summary` AS select\n  ex.year,\n  ex.month,\n  SUM(ex.value) as total_month,\n  SUM(case when ex.value > 0 then ex.value else 0 end) as total_month_gain,\n  SUM(case when ex.value < 0 then ex.value else 0 end) as total_month_loss\nfrom (\n  select\n    strftime(\'%Y\', e.created_date) as year,\n    strftime(\'%M\', e.created_date) as month,\n    e.value\n  from expenses e\n) ex\ngroup by ex.year, ex.month\n');

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
                  'created_date': _dateTimeTc.encode(item.createdDate),
                  'generated': item.generated
                }),
        _tagInsertionAdapter = InsertionAdapter(
            database,
            'tags',
            (Tag item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'color': item.color,
                  'added_time': _dateTimeTc.encode(item.added),
                  'deleted': item.deleted ? 1 : 0
                },
            changeListener),
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
                  'created_date': _dateTimeTc.encode(item.createdDate),
                  'generated': item.generated
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Expense> _expenseInsertionAdapter;

  final InsertionAdapter<Tag> _tagInsertionAdapter;

  final InsertionAdapter<ExpenseTag> _expenseTagInsertionAdapter;

  final UpdateAdapter<Expense> _expenseUpdateAdapter;

  @override
  Future<List<Tag>> getTagsForExpenseId(int id) async {
    return _queryAdapter.queryList(
        'select   t.* from expense_tags et join tags t on t.id = et.tag_id where et.expense_id = ?1',
        mapper: (Map<String, Object?> row) => Tag(id: row['id'] as int?, name: row['name'] as String, description: row['description'] as String?, color: row['color'] as int?, added: _dateTimeTc.decode(row['added_time'] as String), deleted: (row['deleted'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllTagsForExpenseId(int id) async {
    await _queryAdapter.queryNoReturn(
        'delete from expense_tags where expense_id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<ExpenseMonthsView>> getMonths(int limit) async {
    return _queryAdapter.queryList('select * from vw_expense_months limit ?1',
        mapper: (Map<String, Object?> row) =>
            ExpenseMonthsView(row['year'] as int, row['month'] as int),
        arguments: [limit]);
  }

  @override
  Future<List<Expense>> getExpensesByYearAndMonth(
    int year,
    int month,
  ) async {
    return _queryAdapter.queryList(
        'select * from vw_expense_list where strftime(\'%Y\', created_date)=?1 and strftime(\'%M\', created_date)=?2',
        mapper: (Map<String, Object?> row) => Expense(id: row['id'] as int?, value: row['value'] as double, details: row['details'] as String?, createdDate: _dateTimeTc.decode(row['created_date'] as String), generated: row['generated'] as int?),
        arguments: [year, month]);
  }

  @override
  Future<ExpenseMonthsView?> getMonthSummary(
    int year,
    int month,
  ) async {
    return _queryAdapter.query(
        'select * from vw_expense_summary where year=?1 and month=?2',
        mapper: (Map<String, Object?> row) =>
            ExpenseMonthsView(row['year'] as int, row['month'] as int),
        arguments: [year, month]);
  }

  @override
  Future<Expense?> findExpenseById(int id) async {
    return _queryAdapter.query('select * from expense where id=?1',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            value: row['value'] as double,
            details: row['details'] as String?,
            createdDate: _dateTimeTc.decode(row['created_date'] as String),
            generated: row['generated'] as int?),
        arguments: [id]);
  }

  @override
  Future<ExpenseListView?> getViewDataForExpenseId(int id) async {
    return _queryAdapter.query('select * from vw_expense_list where id=?1',
        mapper: (Map<String, Object?> row) => ExpenseListView(
            id: row['id'] as int,
            createdDate: _dateTimeTc.decode(row['created_date'] as String),
            value: row['value'] as double,
            details: row['details'] as String?,
            generated: row['generated'] as int?,
            firstTag: row['first_tag'] as String?,
            totalTags: row['total_tags'] as int),
        arguments: [id]);
  }

  @override
  Future<int?> getExpenseCount() async {
    return _queryAdapter.query('select count(*) from expenses',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getAllExpenseTagCount() async {
    return _queryAdapter.query('select count(*) from expense_tags',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Expense>> getExpenseBatch(
    int batchSize,
    int lastId,
  ) async {
    return _queryAdapter.queryList(
        'select * from expenses where id > ?2 order by id limit ?1',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            value: row['value'] as double,
            details: row['details'] as String?,
            createdDate: _dateTimeTc.decode(row['created_date'] as String),
            generated: row['generated'] as int?),
        arguments: [batchSize, lastId]);
  }

  @override
  Future<List<ExpenseTag>> getExpenseTagsByExpenseId(int id) async {
    return _queryAdapter.queryList(
        'select * from expense_tags where expense_id=?1',
        mapper: (Map<String, Object?> row) => ExpenseTag(
            tagId: row['tag_id'] as int?, expenseId: row['expense_id'] as int?),
        arguments: [id]);
  }

  @override
  Future<int> insert(Expense e) {
    return _expenseInsertionAdapter.insertAndReturnId(
        e, OnConflictStrategy.abort);
  }

  @override
  Future<void> batchInsertExpenses(List<Expense> rows) async {
    await _expenseInsertionAdapter.insertList(rows, OnConflictStrategy.abort);
  }

  @override
  Future<void> batchInsertTags(List<Tag> rows) async {
    await _tagInsertionAdapter.insertList(rows, OnConflictStrategy.abort);
  }

  @override
  Future<void> batchInsertExpenseTags(List<ExpenseTag> rows) async {
    await _expenseTagInsertionAdapter.insertList(
        rows, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertExpenseTag(ExpenseTag e) async {
    await _expenseTagInsertionAdapter.insert(e, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Expense e) async {
    await _expenseUpdateAdapter.update(e, OnConflictStrategy.abort);
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
                  'color': item.color,
                  'added_time': _dateTimeTc.encode(item.added),
                  'deleted': item.deleted ? 1 : 0
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
                  'color': item.color,
                  'added_time': _dateTimeTc.encode(item.added),
                  'deleted': item.deleted ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tag> _tagInsertionAdapter;

  final UpdateAdapter<Tag> _tagUpdateAdapter;

  @override
  Stream<List<Tag>> watchAllTags() {
    return _queryAdapter.queryListStream('select * from tags',
        mapper: (Map<String, Object?> row) => Tag(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            color: row['color'] as int?,
            added: _dateTimeTc.decode(row['added_time'] as String),
            deleted: (row['deleted'] as int) != 0),
        queryableName: 'tags',
        isView: false);
  }

  @override
  Future<List<Tag>> getAllTags() async {
    return _queryAdapter.queryList('select * from tags',
        mapper: (Map<String, Object?> row) => Tag(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            color: row['color'] as int?,
            added: _dateTimeTc.decode(row['added_time'] as String),
            deleted: (row['deleted'] as int) != 0));
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
  Future<int?> getAllTagsCount() async {
    return _queryAdapter.query('select count(*) from tags',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Tag>> getBatch(
    int batchSize,
    int lastId,
  ) async {
    return _queryAdapter.queryList(
        'select * from tags t   where t.id > ?2   order by t.id   limit ?1',
        mapper: (Map<String, Object?> row) => Tag(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            color: row['color'] as int?,
            added: _dateTimeTc.decode(row['added_time'] as String),
            deleted: (row['deleted'] as int) != 0),
        arguments: [batchSize, lastId]);
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
                  'created_date': _dateTimeTc.encode(item.createdDate),
                  'next_insert': _dateTimeTc.encode(item.nextInsert),
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
                  'created_date': _dateTimeTc.encode(item.createdDate),
                  'next_insert': _dateTimeTc.encode(item.nextInsert),
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

  @override
  Future<int?> getAllScheduledExpenseCount() async {
    return _queryAdapter.query('select count(*) from scheduled_expenses',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getAllScheduledExpenseTagCount() async {
    return _queryAdapter.query('select count(*) from scheduled_expense_tags',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<ScheduledExpense>> getScheduledExpenseBatch(
    int batchSize,
    int lastId,
  ) async {
    return _queryAdapter.queryList(
        'select * from scheduled_expenses where id>?2 order by id limit ?1',
        mapper: (Map<String, Object?> row) => ScheduledExpense(
            id: row['id'] as int?,
            value: row['value'] as double,
            details: row['details'] as String?,
            createdDate: _dateTimeTc.decode(row['created_date'] as String),
            nextInsert: _dateTimeTc.decode(row['next_insert'] as String),
            repeatPattern: row['repeat_pattern'] as String),
        arguments: [batchSize, lastId]);
  }

  @override
  Stream<List<ScheduledExpense>> watchScheduledExpenses() {
    return _queryAdapter.queryListStream(
        'select * from scheduled_expenses order by id',
        mapper: (Map<String, Object?> row) => ScheduledExpense(
            id: row['id'] as int?,
            value: row['value'] as double,
            details: row['details'] as String?,
            createdDate: _dateTimeTc.decode(row['created_date'] as String),
            nextInsert: _dateTimeTc.decode(row['next_insert'] as String),
            repeatPattern: row['repeat_pattern'] as String),
        queryableName: 'scheduled_expenses',
        isView: false);
  }

  @override
  Future<List<ScheduledExpenseTag>> getScheduledExpenseTagsById(int id) async {
    return _queryAdapter.queryList(
        'select * from scheduled_expense_tags where scheduled_expense_id=?1',
        mapper: (Map<String, Object?> row) => ScheduledExpenseTag(
            tagId: row['tag_id'] as int?,
            scheduledExpenseId: row['scheduled_expense_id'] as int?),
        arguments: [id]);
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
            createdDate: _dateTimeTc.decode(row['created_date'] as String),
            nextInsert: _dateTimeTc.decode(row['next_insert'] as String),
            repeatPattern: row['repeat_pattern'] as String),
        arguments: [_dateTimeTc.encode(t)]);
  }

  @override
  Future<List<Tag>> getTagsOfScheduledExpense(int id) async {
    return _queryAdapter.queryList(
        'select t.* from scheduled_expense_tags st join tags t on t.id = st.tag_id where st.scheduled_expense_id=?1',
        mapper: (Map<String, Object?> row) => Tag(id: row['id'] as int?, name: row['name'] as String, description: row['description'] as String?, color: row['color'] as int?, added: _dateTimeTc.decode(row['added_time'] as String), deleted: (row['deleted'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> deleteTagsById(int id) async {
    await _queryAdapter.queryNoReturn(
        'delete from scheduled_expense_tag where scheduled_expense_id=?1',
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
  Future<void> insertTagEntity(ScheduledExpenseTag t) async {
    await _scheduledExpenseTagInsertionAdapter.insert(
        t, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(ScheduledExpense e) async {
    await _scheduledExpenseUpdateAdapter.update(e, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeTc = DateTimeTc();
