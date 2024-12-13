// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TagTable extends Tag with TableInfo<$TagTable, TagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _addedMeta = const VerificationMeta('added');
  @override
  late final GeneratedColumn<DateTime> added = GeneratedColumn<DateTime>(
      'added', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, color, added, deleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag';
  @override
  VerificationContext validateIntegrity(Insertable<TagData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('added')) {
      context.handle(
          _addedMeta, added.isAcceptableOrUnknown(data['added']!, _addedMeta));
    } else if (isInserting) {
      context.missing(_addedMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color']),
      added: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $TagTable createAlias(String alias) {
    return $TagTable(attachedDatabase, alias);
  }
}

class TagData extends DataClass implements Insertable<TagData> {
  final int id;
  final String name;
  final String? description;
  final int? color;
  final DateTime added;
  final bool deleted;
  const TagData(
      {required this.id,
      required this.name,
      this.description,
      this.color,
      required this.added,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    map['added'] = Variable<DateTime>(added);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  TagCompanion toCompanion(bool nullToAbsent) {
    return TagCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      added: Value(added),
      deleted: Value(deleted),
    );
  }

  factory TagData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      color: serializer.fromJson<int?>(json['color']),
      added: serializer.fromJson<DateTime>(json['added']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'color': serializer.toJson<int?>(color),
      'added': serializer.toJson<DateTime>(added),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  TagData copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<int?> color = const Value.absent(),
          DateTime? added,
          bool? deleted}) =>
      TagData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        color: color.present ? color.value : this.color,
        added: added ?? this.added,
        deleted: deleted ?? this.deleted,
      );
  TagData copyWithCompanion(TagCompanion data) {
    return TagData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      color: data.color.present ? data.color.value : this.color,
      added: data.added.present ? data.added.value : this.added,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('added: $added, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, color, added, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.color == this.color &&
          other.added == this.added &&
          other.deleted == this.deleted);
}

class TagCompanion extends UpdateCompanion<TagData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int?> color;
  final Value<DateTime> added;
  final Value<bool> deleted;
  const TagCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.added = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  TagCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    required DateTime added,
    this.deleted = const Value.absent(),
  })  : name = Value(name),
        added = Value(added);
  static Insertable<TagData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? color,
    Expression<DateTime>? added,
    Expression<bool>? deleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (added != null) 'added': added,
      if (deleted != null) 'deleted': deleted,
    });
  }

  TagCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int?>? color,
      Value<DateTime>? added,
      Value<bool>? deleted}) {
    return TagCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      added: added ?? this.added,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (added.present) {
      map['added'] = Variable<DateTime>(added.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('added: $added, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }
}

class $ExpenseTable extends Expense with TableInfo<$ExpenseTable, ExpenseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _generatedMeta =
      const VerificationMeta('generated');
  @override
  late final GeneratedColumn<int> generated = GeneratedColumn<int>(
      'generated', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, value, details, createdDate, generated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    if (data.containsKey('generated')) {
      context.handle(_generatedMeta,
          generated.isAcceptableOrUnknown(data['generated']!, _generatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      generated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}generated']),
    );
  }

  @override
  $ExpenseTable createAlias(String alias) {
    return $ExpenseTable(attachedDatabase, alias);
  }
}

class ExpenseData extends DataClass implements Insertable<ExpenseData> {
  final int id;
  final double value;
  final String? details;
  final DateTime createdDate;
  final int? generated;
  const ExpenseData(
      {required this.id,
      required this.value,
      this.details,
      required this.createdDate,
      this.generated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['value'] = Variable<double>(value);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_date'] = Variable<DateTime>(createdDate);
    if (!nullToAbsent || generated != null) {
      map['generated'] = Variable<int>(generated);
    }
    return map;
  }

  ExpenseCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCompanion(
      id: Value(id),
      value: Value(value),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdDate: Value(createdDate),
      generated: generated == null && nullToAbsent
          ? const Value.absent()
          : Value(generated),
    );
  }

  factory ExpenseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseData(
      id: serializer.fromJson<int>(json['id']),
      value: serializer.fromJson<double>(json['value']),
      details: serializer.fromJson<String?>(json['details']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      generated: serializer.fromJson<int?>(json['generated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'value': serializer.toJson<double>(value),
      'details': serializer.toJson<String?>(details),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'generated': serializer.toJson<int?>(generated),
    };
  }

  ExpenseData copyWith(
          {int? id,
          double? value,
          Value<String?> details = const Value.absent(),
          DateTime? createdDate,
          Value<int?> generated = const Value.absent()}) =>
      ExpenseData(
        id: id ?? this.id,
        value: value ?? this.value,
        details: details.present ? details.value : this.details,
        createdDate: createdDate ?? this.createdDate,
        generated: generated.present ? generated.value : this.generated,
      );
  ExpenseData copyWithCompanion(ExpenseCompanion data) {
    return ExpenseData(
      id: data.id.present ? data.id.value : this.id,
      value: data.value.present ? data.value.value : this.value,
      details: data.details.present ? data.details.value : this.details,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      generated: data.generated.present ? data.generated.value : this.generated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseData(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('details: $details, ')
          ..write('createdDate: $createdDate, ')
          ..write('generated: $generated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, value, details, createdDate, generated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseData &&
          other.id == this.id &&
          other.value == this.value &&
          other.details == this.details &&
          other.createdDate == this.createdDate &&
          other.generated == this.generated);
}

class ExpenseCompanion extends UpdateCompanion<ExpenseData> {
  final Value<int> id;
  final Value<double> value;
  final Value<String?> details;
  final Value<DateTime> createdDate;
  final Value<int?> generated;
  const ExpenseCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.details = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.generated = const Value.absent(),
  });
  ExpenseCompanion.insert({
    this.id = const Value.absent(),
    required double value,
    this.details = const Value.absent(),
    required DateTime createdDate,
    this.generated = const Value.absent(),
  })  : value = Value(value),
        createdDate = Value(createdDate);
  static Insertable<ExpenseData> custom({
    Expression<int>? id,
    Expression<double>? value,
    Expression<String>? details,
    Expression<DateTime>? createdDate,
    Expression<int>? generated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
      if (details != null) 'details': details,
      if (createdDate != null) 'created_date': createdDate,
      if (generated != null) 'generated': generated,
    });
  }

  ExpenseCompanion copyWith(
      {Value<int>? id,
      Value<double>? value,
      Value<String?>? details,
      Value<DateTime>? createdDate,
      Value<int?>? generated}) {
    return ExpenseCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      details: details ?? this.details,
      createdDate: createdDate ?? this.createdDate,
      generated: generated ?? this.generated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (generated.present) {
      map['generated'] = Variable<int>(generated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('details: $details, ')
          ..write('createdDate: $createdDate, ')
          ..write('generated: $generated')
          ..write(')'))
        .toString();
  }
}

class $ExpenseTagTable extends ExpenseTag
    with TableInfo<$ExpenseTagTable, ExpenseTagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseTagTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tag (id)'));
  static const VerificationMeta _expenseIdMeta =
      const VerificationMeta('expenseId');
  @override
  late final GeneratedColumn<int> expenseId = GeneratedColumn<int>(
      'expense_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES expense (id)'));
  @override
  List<GeneratedColumn> get $columns => [tagId, expenseId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_tag';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseTagData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('expense_id')) {
      context.handle(_expenseIdMeta,
          expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta));
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tagId, expenseId};
  @override
  ExpenseTagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseTagData(
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
      expenseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expense_id'])!,
    );
  }

  @override
  $ExpenseTagTable createAlias(String alias) {
    return $ExpenseTagTable(attachedDatabase, alias);
  }
}

class ExpenseTagData extends DataClass implements Insertable<ExpenseTagData> {
  final int tagId;
  final int expenseId;
  const ExpenseTagData({required this.tagId, required this.expenseId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tag_id'] = Variable<int>(tagId);
    map['expense_id'] = Variable<int>(expenseId);
    return map;
  }

  ExpenseTagCompanion toCompanion(bool nullToAbsent) {
    return ExpenseTagCompanion(
      tagId: Value(tagId),
      expenseId: Value(expenseId),
    );
  }

  factory ExpenseTagData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseTagData(
      tagId: serializer.fromJson<int>(json['tagId']),
      expenseId: serializer.fromJson<int>(json['expenseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tagId': serializer.toJson<int>(tagId),
      'expenseId': serializer.toJson<int>(expenseId),
    };
  }

  ExpenseTagData copyWith({int? tagId, int? expenseId}) => ExpenseTagData(
        tagId: tagId ?? this.tagId,
        expenseId: expenseId ?? this.expenseId,
      );
  ExpenseTagData copyWithCompanion(ExpenseTagCompanion data) {
    return ExpenseTagData(
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTagData(')
          ..write('tagId: $tagId, ')
          ..write('expenseId: $expenseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tagId, expenseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseTagData &&
          other.tagId == this.tagId &&
          other.expenseId == this.expenseId);
}

class ExpenseTagCompanion extends UpdateCompanion<ExpenseTagData> {
  final Value<int> tagId;
  final Value<int> expenseId;
  final Value<int> rowid;
  const ExpenseTagCompanion({
    this.tagId = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseTagCompanion.insert({
    required int tagId,
    required int expenseId,
    this.rowid = const Value.absent(),
  })  : tagId = Value(tagId),
        expenseId = Value(expenseId);
  static Insertable<ExpenseTagData> custom({
    Expression<int>? tagId,
    Expression<int>? expenseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tagId != null) 'tag_id': tagId,
      if (expenseId != null) 'expense_id': expenseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseTagCompanion copyWith(
      {Value<int>? tagId, Value<int>? expenseId, Value<int>? rowid}) {
    return ExpenseTagCompanion(
      tagId: tagId ?? this.tagId,
      expenseId: expenseId ?? this.expenseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTagCompanion(')
          ..write('tagId: $tagId, ')
          ..write('expenseId: $expenseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingTable extends AppSetting
    with TableInfo<$AppSettingTable, AppSettingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<int> key = GeneratedColumn<int>(
      'key', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_setting';
  @override
  VerificationContext validateIntegrity(Insertable<AppSettingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
    );
  }

  @override
  $AppSettingTable createAlias(String alias) {
    return $AppSettingTable(attachedDatabase, alias);
  }
}

class AppSettingData extends DataClass implements Insertable<AppSettingData> {
  final int key;
  final String? value;
  const AppSettingData({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<int>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppSettingCompanion toCompanion(bool nullToAbsent) {
    return AppSettingCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory AppSettingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingData(
      key: serializer.fromJson<int>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<int>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppSettingData copyWith(
          {int? key, Value<String?> value = const Value.absent()}) =>
      AppSettingData(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
      );
  AppSettingData copyWithCompanion(AppSettingCompanion data) {
    return AppSettingData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingCompanion extends UpdateCompanion<AppSettingData> {
  final Value<int> key;
  final Value<String?> value;
  const AppSettingCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  AppSettingCompanion.insert({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  static Insertable<AppSettingData> custom({
    Expression<int>? key,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  AppSettingCompanion copyWith({Value<int>? key, Value<String?>? value}) {
    return AppSettingCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<int>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingCompanion(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $ScheduledExpenseTable extends ScheduledExpense
    with TableInfo<$ScheduledExpenseTable, ScheduledExpenseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledExpenseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _nextInsertMeta =
      const VerificationMeta('nextInsert');
  @override
  late final GeneratedColumn<DateTime> nextInsert = GeneratedColumn<DateTime>(
      'next_insert', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _repeatDailyMeta =
      const VerificationMeta('repeatDaily');
  @override
  late final GeneratedColumn<bool> repeatDaily = GeneratedColumn<bool>(
      'repeat_daily', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("repeat_daily" IN (0, 1))'));
  static const VerificationMeta _repeatWeeklyMeta =
      const VerificationMeta('repeatWeekly');
  @override
  late final GeneratedColumn<bool> repeatWeekly = GeneratedColumn<bool>(
      'repeat_weekly', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("repeat_weekly" IN (0, 1))'));
  static const VerificationMeta _repeatMonthlyMeta =
      const VerificationMeta('repeatMonthly');
  @override
  late final GeneratedColumn<bool> repeatMonthly = GeneratedColumn<bool>(
      'repeat_monthly', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("repeat_monthly" IN (0, 1))'));
  static const VerificationMeta _repeatYearlyMeta =
      const VerificationMeta('repeatYearly');
  @override
  late final GeneratedColumn<bool> repeatYearly = GeneratedColumn<bool>(
      'repeat_yearly', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("repeat_yearly" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        value,
        details,
        createdDate,
        nextInsert,
        repeatDaily,
        repeatWeekly,
        repeatMonthly,
        repeatYearly
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_expense';
  @override
  VerificationContext validateIntegrity(
      Insertable<ScheduledExpenseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    } else if (isInserting) {
      context.missing(_detailsMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    if (data.containsKey('next_insert')) {
      context.handle(
          _nextInsertMeta,
          nextInsert.isAcceptableOrUnknown(
              data['next_insert']!, _nextInsertMeta));
    } else if (isInserting) {
      context.missing(_nextInsertMeta);
    }
    if (data.containsKey('repeat_daily')) {
      context.handle(
          _repeatDailyMeta,
          repeatDaily.isAcceptableOrUnknown(
              data['repeat_daily']!, _repeatDailyMeta));
    } else if (isInserting) {
      context.missing(_repeatDailyMeta);
    }
    if (data.containsKey('repeat_weekly')) {
      context.handle(
          _repeatWeeklyMeta,
          repeatWeekly.isAcceptableOrUnknown(
              data['repeat_weekly']!, _repeatWeeklyMeta));
    } else if (isInserting) {
      context.missing(_repeatWeeklyMeta);
    }
    if (data.containsKey('repeat_monthly')) {
      context.handle(
          _repeatMonthlyMeta,
          repeatMonthly.isAcceptableOrUnknown(
              data['repeat_monthly']!, _repeatMonthlyMeta));
    } else if (isInserting) {
      context.missing(_repeatMonthlyMeta);
    }
    if (data.containsKey('repeat_yearly')) {
      context.handle(
          _repeatYearlyMeta,
          repeatYearly.isAcceptableOrUnknown(
              data['repeat_yearly']!, _repeatYearlyMeta));
    } else if (isInserting) {
      context.missing(_repeatYearlyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledExpenseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledExpenseData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      nextInsert: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_insert'])!,
      repeatDaily: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}repeat_daily'])!,
      repeatWeekly: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}repeat_weekly'])!,
      repeatMonthly: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}repeat_monthly'])!,
      repeatYearly: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}repeat_yearly'])!,
    );
  }

  @override
  $ScheduledExpenseTable createAlias(String alias) {
    return $ScheduledExpenseTable(attachedDatabase, alias);
  }
}

class ScheduledExpenseData extends DataClass
    implements Insertable<ScheduledExpenseData> {
  final int id;
  final double value;
  final String details;
  final DateTime createdDate;
  final DateTime nextInsert;
  final bool repeatDaily;
  final bool repeatWeekly;
  final bool repeatMonthly;
  final bool repeatYearly;
  const ScheduledExpenseData(
      {required this.id,
      required this.value,
      required this.details,
      required this.createdDate,
      required this.nextInsert,
      required this.repeatDaily,
      required this.repeatWeekly,
      required this.repeatMonthly,
      required this.repeatYearly});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['value'] = Variable<double>(value);
    map['details'] = Variable<String>(details);
    map['created_date'] = Variable<DateTime>(createdDate);
    map['next_insert'] = Variable<DateTime>(nextInsert);
    map['repeat_daily'] = Variable<bool>(repeatDaily);
    map['repeat_weekly'] = Variable<bool>(repeatWeekly);
    map['repeat_monthly'] = Variable<bool>(repeatMonthly);
    map['repeat_yearly'] = Variable<bool>(repeatYearly);
    return map;
  }

  ScheduledExpenseCompanion toCompanion(bool nullToAbsent) {
    return ScheduledExpenseCompanion(
      id: Value(id),
      value: Value(value),
      details: Value(details),
      createdDate: Value(createdDate),
      nextInsert: Value(nextInsert),
      repeatDaily: Value(repeatDaily),
      repeatWeekly: Value(repeatWeekly),
      repeatMonthly: Value(repeatMonthly),
      repeatYearly: Value(repeatYearly),
    );
  }

  factory ScheduledExpenseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledExpenseData(
      id: serializer.fromJson<int>(json['id']),
      value: serializer.fromJson<double>(json['value']),
      details: serializer.fromJson<String>(json['details']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      nextInsert: serializer.fromJson<DateTime>(json['nextInsert']),
      repeatDaily: serializer.fromJson<bool>(json['repeatDaily']),
      repeatWeekly: serializer.fromJson<bool>(json['repeatWeekly']),
      repeatMonthly: serializer.fromJson<bool>(json['repeatMonthly']),
      repeatYearly: serializer.fromJson<bool>(json['repeatYearly']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'value': serializer.toJson<double>(value),
      'details': serializer.toJson<String>(details),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'nextInsert': serializer.toJson<DateTime>(nextInsert),
      'repeatDaily': serializer.toJson<bool>(repeatDaily),
      'repeatWeekly': serializer.toJson<bool>(repeatWeekly),
      'repeatMonthly': serializer.toJson<bool>(repeatMonthly),
      'repeatYearly': serializer.toJson<bool>(repeatYearly),
    };
  }

  ScheduledExpenseData copyWith(
          {int? id,
          double? value,
          String? details,
          DateTime? createdDate,
          DateTime? nextInsert,
          bool? repeatDaily,
          bool? repeatWeekly,
          bool? repeatMonthly,
          bool? repeatYearly}) =>
      ScheduledExpenseData(
        id: id ?? this.id,
        value: value ?? this.value,
        details: details ?? this.details,
        createdDate: createdDate ?? this.createdDate,
        nextInsert: nextInsert ?? this.nextInsert,
        repeatDaily: repeatDaily ?? this.repeatDaily,
        repeatWeekly: repeatWeekly ?? this.repeatWeekly,
        repeatMonthly: repeatMonthly ?? this.repeatMonthly,
        repeatYearly: repeatYearly ?? this.repeatYearly,
      );
  ScheduledExpenseData copyWithCompanion(ScheduledExpenseCompanion data) {
    return ScheduledExpenseData(
      id: data.id.present ? data.id.value : this.id,
      value: data.value.present ? data.value.value : this.value,
      details: data.details.present ? data.details.value : this.details,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      nextInsert:
          data.nextInsert.present ? data.nextInsert.value : this.nextInsert,
      repeatDaily:
          data.repeatDaily.present ? data.repeatDaily.value : this.repeatDaily,
      repeatWeekly: data.repeatWeekly.present
          ? data.repeatWeekly.value
          : this.repeatWeekly,
      repeatMonthly: data.repeatMonthly.present
          ? data.repeatMonthly.value
          : this.repeatMonthly,
      repeatYearly: data.repeatYearly.present
          ? data.repeatYearly.value
          : this.repeatYearly,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledExpenseData(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('details: $details, ')
          ..write('createdDate: $createdDate, ')
          ..write('nextInsert: $nextInsert, ')
          ..write('repeatDaily: $repeatDaily, ')
          ..write('repeatWeekly: $repeatWeekly, ')
          ..write('repeatMonthly: $repeatMonthly, ')
          ..write('repeatYearly: $repeatYearly')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, value, details, createdDate, nextInsert,
      repeatDaily, repeatWeekly, repeatMonthly, repeatYearly);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledExpenseData &&
          other.id == this.id &&
          other.value == this.value &&
          other.details == this.details &&
          other.createdDate == this.createdDate &&
          other.nextInsert == this.nextInsert &&
          other.repeatDaily == this.repeatDaily &&
          other.repeatWeekly == this.repeatWeekly &&
          other.repeatMonthly == this.repeatMonthly &&
          other.repeatYearly == this.repeatYearly);
}

class ScheduledExpenseCompanion extends UpdateCompanion<ScheduledExpenseData> {
  final Value<int> id;
  final Value<double> value;
  final Value<String> details;
  final Value<DateTime> createdDate;
  final Value<DateTime> nextInsert;
  final Value<bool> repeatDaily;
  final Value<bool> repeatWeekly;
  final Value<bool> repeatMonthly;
  final Value<bool> repeatYearly;
  const ScheduledExpenseCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.details = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.nextInsert = const Value.absent(),
    this.repeatDaily = const Value.absent(),
    this.repeatWeekly = const Value.absent(),
    this.repeatMonthly = const Value.absent(),
    this.repeatYearly = const Value.absent(),
  });
  ScheduledExpenseCompanion.insert({
    this.id = const Value.absent(),
    required double value,
    required String details,
    required DateTime createdDate,
    required DateTime nextInsert,
    required bool repeatDaily,
    required bool repeatWeekly,
    required bool repeatMonthly,
    required bool repeatYearly,
  })  : value = Value(value),
        details = Value(details),
        createdDate = Value(createdDate),
        nextInsert = Value(nextInsert),
        repeatDaily = Value(repeatDaily),
        repeatWeekly = Value(repeatWeekly),
        repeatMonthly = Value(repeatMonthly),
        repeatYearly = Value(repeatYearly);
  static Insertable<ScheduledExpenseData> custom({
    Expression<int>? id,
    Expression<double>? value,
    Expression<String>? details,
    Expression<DateTime>? createdDate,
    Expression<DateTime>? nextInsert,
    Expression<bool>? repeatDaily,
    Expression<bool>? repeatWeekly,
    Expression<bool>? repeatMonthly,
    Expression<bool>? repeatYearly,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
      if (details != null) 'details': details,
      if (createdDate != null) 'created_date': createdDate,
      if (nextInsert != null) 'next_insert': nextInsert,
      if (repeatDaily != null) 'repeat_daily': repeatDaily,
      if (repeatWeekly != null) 'repeat_weekly': repeatWeekly,
      if (repeatMonthly != null) 'repeat_monthly': repeatMonthly,
      if (repeatYearly != null) 'repeat_yearly': repeatYearly,
    });
  }

  ScheduledExpenseCompanion copyWith(
      {Value<int>? id,
      Value<double>? value,
      Value<String>? details,
      Value<DateTime>? createdDate,
      Value<DateTime>? nextInsert,
      Value<bool>? repeatDaily,
      Value<bool>? repeatWeekly,
      Value<bool>? repeatMonthly,
      Value<bool>? repeatYearly}) {
    return ScheduledExpenseCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      details: details ?? this.details,
      createdDate: createdDate ?? this.createdDate,
      nextInsert: nextInsert ?? this.nextInsert,
      repeatDaily: repeatDaily ?? this.repeatDaily,
      repeatWeekly: repeatWeekly ?? this.repeatWeekly,
      repeatMonthly: repeatMonthly ?? this.repeatMonthly,
      repeatYearly: repeatYearly ?? this.repeatYearly,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (nextInsert.present) {
      map['next_insert'] = Variable<DateTime>(nextInsert.value);
    }
    if (repeatDaily.present) {
      map['repeat_daily'] = Variable<bool>(repeatDaily.value);
    }
    if (repeatWeekly.present) {
      map['repeat_weekly'] = Variable<bool>(repeatWeekly.value);
    }
    if (repeatMonthly.present) {
      map['repeat_monthly'] = Variable<bool>(repeatMonthly.value);
    }
    if (repeatYearly.present) {
      map['repeat_yearly'] = Variable<bool>(repeatYearly.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledExpenseCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('details: $details, ')
          ..write('createdDate: $createdDate, ')
          ..write('nextInsert: $nextInsert, ')
          ..write('repeatDaily: $repeatDaily, ')
          ..write('repeatWeekly: $repeatWeekly, ')
          ..write('repeatMonthly: $repeatMonthly, ')
          ..write('repeatYearly: $repeatYearly')
          ..write(')'))
        .toString();
  }
}

class $ScheduledExpenseTagTable extends ScheduledExpenseTag
    with TableInfo<$ScheduledExpenseTagTable, ScheduledExpenseTagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledExpenseTagTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tag (id)'));
  static const VerificationMeta _scheduledExpenseIdMeta =
      const VerificationMeta('scheduledExpenseId');
  @override
  late final GeneratedColumn<int> scheduledExpenseId = GeneratedColumn<int>(
      'scheduled_expense_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES scheduled_expense (id)'));
  @override
  List<GeneratedColumn> get $columns => [tagId, scheduledExpenseId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_expense_tag';
  @override
  VerificationContext validateIntegrity(
      Insertable<ScheduledExpenseTagData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('scheduled_expense_id')) {
      context.handle(
          _scheduledExpenseIdMeta,
          scheduledExpenseId.isAcceptableOrUnknown(
              data['scheduled_expense_id']!, _scheduledExpenseIdMeta));
    } else if (isInserting) {
      context.missing(_scheduledExpenseIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tagId, scheduledExpenseId};
  @override
  ScheduledExpenseTagData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledExpenseTagData(
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
      scheduledExpenseId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}scheduled_expense_id'])!,
    );
  }

  @override
  $ScheduledExpenseTagTable createAlias(String alias) {
    return $ScheduledExpenseTagTable(attachedDatabase, alias);
  }
}

class ScheduledExpenseTagData extends DataClass
    implements Insertable<ScheduledExpenseTagData> {
  final int tagId;
  final int scheduledExpenseId;
  const ScheduledExpenseTagData(
      {required this.tagId, required this.scheduledExpenseId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tag_id'] = Variable<int>(tagId);
    map['scheduled_expense_id'] = Variable<int>(scheduledExpenseId);
    return map;
  }

  ScheduledExpenseTagCompanion toCompanion(bool nullToAbsent) {
    return ScheduledExpenseTagCompanion(
      tagId: Value(tagId),
      scheduledExpenseId: Value(scheduledExpenseId),
    );
  }

  factory ScheduledExpenseTagData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledExpenseTagData(
      tagId: serializer.fromJson<int>(json['tagId']),
      scheduledExpenseId: serializer.fromJson<int>(json['scheduledExpenseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tagId': serializer.toJson<int>(tagId),
      'scheduledExpenseId': serializer.toJson<int>(scheduledExpenseId),
    };
  }

  ScheduledExpenseTagData copyWith({int? tagId, int? scheduledExpenseId}) =>
      ScheduledExpenseTagData(
        tagId: tagId ?? this.tagId,
        scheduledExpenseId: scheduledExpenseId ?? this.scheduledExpenseId,
      );
  ScheduledExpenseTagData copyWithCompanion(ScheduledExpenseTagCompanion data) {
    return ScheduledExpenseTagData(
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      scheduledExpenseId: data.scheduledExpenseId.present
          ? data.scheduledExpenseId.value
          : this.scheduledExpenseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledExpenseTagData(')
          ..write('tagId: $tagId, ')
          ..write('scheduledExpenseId: $scheduledExpenseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tagId, scheduledExpenseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledExpenseTagData &&
          other.tagId == this.tagId &&
          other.scheduledExpenseId == this.scheduledExpenseId);
}

class ScheduledExpenseTagCompanion
    extends UpdateCompanion<ScheduledExpenseTagData> {
  final Value<int> tagId;
  final Value<int> scheduledExpenseId;
  final Value<int> rowid;
  const ScheduledExpenseTagCompanion({
    this.tagId = const Value.absent(),
    this.scheduledExpenseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduledExpenseTagCompanion.insert({
    required int tagId,
    required int scheduledExpenseId,
    this.rowid = const Value.absent(),
  })  : tagId = Value(tagId),
        scheduledExpenseId = Value(scheduledExpenseId);
  static Insertable<ScheduledExpenseTagData> custom({
    Expression<int>? tagId,
    Expression<int>? scheduledExpenseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tagId != null) 'tag_id': tagId,
      if (scheduledExpenseId != null)
        'scheduled_expense_id': scheduledExpenseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduledExpenseTagCompanion copyWith(
      {Value<int>? tagId, Value<int>? scheduledExpenseId, Value<int>? rowid}) {
    return ScheduledExpenseTagCompanion(
      tagId: tagId ?? this.tagId,
      scheduledExpenseId: scheduledExpenseId ?? this.scheduledExpenseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (scheduledExpenseId.present) {
      map['scheduled_expense_id'] = Variable<int>(scheduledExpenseId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledExpenseTagCompanion(')
          ..write('tagId: $tagId, ')
          ..write('scheduledExpenseId: $scheduledExpenseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ExpenseListViewData extends DataClass {
  final int id;
  final DateTime createdDate;
  final double value;
  final String? details;
  final int? generated;
  final int? totalTags;
  final String? firstTag;
  const ExpenseListViewData(
      {required this.id,
      required this.createdDate,
      required this.value,
      this.details,
      this.generated,
      this.totalTags,
      this.firstTag});
  factory ExpenseListViewData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseListViewData(
      id: serializer.fromJson<int>(json['id']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      value: serializer.fromJson<double>(json['value']),
      details: serializer.fromJson<String?>(json['details']),
      generated: serializer.fromJson<int?>(json['generated']),
      totalTags: serializer.fromJson<int?>(json['totalTags']),
      firstTag: serializer.fromJson<String?>(json['firstTag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'value': serializer.toJson<double>(value),
      'details': serializer.toJson<String?>(details),
      'generated': serializer.toJson<int?>(generated),
      'totalTags': serializer.toJson<int?>(totalTags),
      'firstTag': serializer.toJson<String?>(firstTag),
    };
  }

  ExpenseListViewData copyWith(
          {int? id,
          DateTime? createdDate,
          double? value,
          Value<String?> details = const Value.absent(),
          Value<int?> generated = const Value.absent(),
          Value<int?> totalTags = const Value.absent(),
          Value<String?> firstTag = const Value.absent()}) =>
      ExpenseListViewData(
        id: id ?? this.id,
        createdDate: createdDate ?? this.createdDate,
        value: value ?? this.value,
        details: details.present ? details.value : this.details,
        generated: generated.present ? generated.value : this.generated,
        totalTags: totalTags.present ? totalTags.value : this.totalTags,
        firstTag: firstTag.present ? firstTag.value : this.firstTag,
      );
  @override
  String toString() {
    return (StringBuffer('ExpenseListViewData(')
          ..write('id: $id, ')
          ..write('createdDate: $createdDate, ')
          ..write('value: $value, ')
          ..write('details: $details, ')
          ..write('generated: $generated, ')
          ..write('totalTags: $totalTags, ')
          ..write('firstTag: $firstTag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, createdDate, value, details, generated, totalTags, firstTag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseListViewData &&
          other.id == this.id &&
          other.createdDate == this.createdDate &&
          other.value == this.value &&
          other.details == this.details &&
          other.generated == this.generated &&
          other.totalTags == this.totalTags &&
          other.firstTag == this.firstTag);
}

class $ExpenseListViewView
    extends ViewInfo<$ExpenseListViewView, ExpenseListViewData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$AppDatabase attachedDatabase;
  $ExpenseListViewView(this.attachedDatabase, [this._alias]);
  $ExpenseTable get expenses => attachedDatabase.expense.createAlias('t0');
  $TagTable get tags => attachedDatabase.tag.createAlias('t1');
  $ExpenseTagTable get expenseTags =>
      attachedDatabase.expenseTag.createAlias('t2');
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdDate, value, details, generated, totalTags, firstTag];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'expense_list_view';
  @override
  Map<SqlDialect, String>? get createViewStatements => null;
  @override
  $ExpenseListViewView get asDslTable => this;
  @override
  ExpenseListViewData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseListViewData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      generated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}generated']),
      totalTags: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_tags']),
      firstTag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_tag']),
    );
  }

  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      generatedAs: GeneratedAs(expenses.id, false), type: DriftSqlType.int);
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      generatedAs: GeneratedAs(expenses.createdDate, false),
      type: DriftSqlType.dateTime);
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      generatedAs: GeneratedAs(expenses.value, false),
      type: DriftSqlType.double);
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      generatedAs: GeneratedAs(expenses.details, false),
      type: DriftSqlType.string);
  late final GeneratedColumn<int> generated = GeneratedColumn<int>(
      'generated', aliasedName, true,
      generatedAs: GeneratedAs(expenses.generated, false),
      type: DriftSqlType.int);
  late final GeneratedColumn<int> totalTags = GeneratedColumn<int>(
      'total_tags', aliasedName, true,
      generatedAs: GeneratedAs(BaseAggregate(tags.id).count(), false),
      type: DriftSqlType.int);
  late final GeneratedColumn<String> firstTag = GeneratedColumn<String>(
      'first_tag', aliasedName, true,
      generatedAs: GeneratedAs(BaseAggregate(tags.name).min(), false),
      type: DriftSqlType.string);
  @override
  $ExpenseListViewView createAlias(String alias) {
    return $ExpenseListViewView(attachedDatabase, alias);
  }

  @override
  Query? get query =>
      (attachedDatabase.selectOnly(expenses)..addColumns($columns)).join([
        leftOuterJoin(expenseTags, expenseTags.expenseId.equalsExp(expenses.id),
            useColumns: false),
        leftOuterJoin(tags, tags.id.equalsExp(expenseTags.tagId),
            useColumns: false)
      ])
        ..groupBy([
          expenses.id,
          expenses.createdDate,
          expenses.value,
          expenses.details,
          expenses.generated
        ])
        ..orderBy([
          OrderingTerm(expression: expenses.createdDate, mode: OrderingMode.asc)
        ]);
  @override
  Set<String> get readTables => const {'expense', 'tag', 'expense_tag'};
}

class ExpenseMonthSummaryViewData extends DataClass {
  final int? year;
  final int? month;
  final double? totalMonth;
  final double? totalMonthGain;
  final double? totalMonthLoss;
  const ExpenseMonthSummaryViewData(
      {this.year,
      this.month,
      this.totalMonth,
      this.totalMonthGain,
      this.totalMonthLoss});
  factory ExpenseMonthSummaryViewData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseMonthSummaryViewData(
      year: serializer.fromJson<int?>(json['year']),
      month: serializer.fromJson<int?>(json['month']),
      totalMonth: serializer.fromJson<double?>(json['totalMonth']),
      totalMonthGain: serializer.fromJson<double?>(json['totalMonthGain']),
      totalMonthLoss: serializer.fromJson<double?>(json['totalMonthLoss']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'year': serializer.toJson<int?>(year),
      'month': serializer.toJson<int?>(month),
      'totalMonth': serializer.toJson<double?>(totalMonth),
      'totalMonthGain': serializer.toJson<double?>(totalMonthGain),
      'totalMonthLoss': serializer.toJson<double?>(totalMonthLoss),
    };
  }

  ExpenseMonthSummaryViewData copyWith(
          {Value<int?> year = const Value.absent(),
          Value<int?> month = const Value.absent(),
          Value<double?> totalMonth = const Value.absent(),
          Value<double?> totalMonthGain = const Value.absent(),
          Value<double?> totalMonthLoss = const Value.absent()}) =>
      ExpenseMonthSummaryViewData(
        year: year.present ? year.value : this.year,
        month: month.present ? month.value : this.month,
        totalMonth: totalMonth.present ? totalMonth.value : this.totalMonth,
        totalMonthGain:
            totalMonthGain.present ? totalMonthGain.value : this.totalMonthGain,
        totalMonthLoss:
            totalMonthLoss.present ? totalMonthLoss.value : this.totalMonthLoss,
      );
  @override
  String toString() {
    return (StringBuffer('ExpenseMonthSummaryViewData(')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('totalMonth: $totalMonth, ')
          ..write('totalMonthGain: $totalMonthGain, ')
          ..write('totalMonthLoss: $totalMonthLoss')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(year, month, totalMonth, totalMonthGain, totalMonthLoss);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseMonthSummaryViewData &&
          other.year == this.year &&
          other.month == this.month &&
          other.totalMonth == this.totalMonth &&
          other.totalMonthGain == this.totalMonthGain &&
          other.totalMonthLoss == this.totalMonthLoss);
}

class $ExpenseMonthSummaryViewView
    extends ViewInfo<$ExpenseMonthSummaryViewView, ExpenseMonthSummaryViewData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$AppDatabase attachedDatabase;
  $ExpenseMonthSummaryViewView(this.attachedDatabase, [this._alias]);
  $ExpenseTable get expenses => attachedDatabase.expense.createAlias('t0');
  @override
  List<GeneratedColumn> get $columns =>
      [year, month, totalMonth, totalMonthGain, totalMonthLoss];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'expense_month_summary_view';
  @override
  Map<SqlDialect, String>? get createViewStatements => null;
  @override
  $ExpenseMonthSummaryViewView get asDslTable => this;
  @override
  ExpenseMonthSummaryViewData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseMonthSummaryViewData(
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year']),
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month']),
      totalMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_month']),
      totalMonthGain: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_month_gain']),
      totalMonthLoss: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_month_loss']),
    );
  }

  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, true,
      generatedAs: GeneratedAs(expenses.createdDate.year, false),
      type: DriftSqlType.int);
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, true,
      generatedAs: GeneratedAs(expenses.createdDate.month, false),
      type: DriftSqlType.int);
  late final GeneratedColumn<double> totalMonth = GeneratedColumn<double>(
      'total_month', aliasedName, true,
      generatedAs:
          GeneratedAs(ArithmeticAggregates(expenses.value).sum(), false),
      type: DriftSqlType.double);
  late final GeneratedColumn<double> totalMonthGain = GeneratedColumn<double>(
      'total_month_gain', aliasedName, true,
      generatedAs: GeneratedAs(
          ArithmeticAggregates(expenses.value).sum(
              filter: ComparableExpr(expenses.value).isSmallerThanValue(0)),
          false),
      type: DriftSqlType.double);
  late final GeneratedColumn<double> totalMonthLoss = GeneratedColumn<double>(
      'total_month_loss', aliasedName, true,
      generatedAs: GeneratedAs(
          ArithmeticAggregates(expenses.value)
              .sum(filter: ComparableExpr(expenses.value).isBiggerThanValue(0)),
          false),
      type: DriftSqlType.double);
  @override
  $ExpenseMonthSummaryViewView createAlias(String alias) {
    return $ExpenseMonthSummaryViewView(attachedDatabase, alias);
  }

  @override
  Query? get query =>
      (attachedDatabase.selectOnly(expenses)..addColumns($columns)).join([])
        ..groupBy([year, month])
        ..orderBy([
          OrderingTerm(expression: year, mode: OrderingMode.desc),
          OrderingTerm(expression: month, mode: OrderingMode.desc)
        ]);
  @override
  Set<String> get readTables => const {'expense'};
}

class ExpenseMonthsViewData extends DataClass {
  final int? year;
  final int? month;
  const ExpenseMonthsViewData({this.year, this.month});
  factory ExpenseMonthsViewData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseMonthsViewData(
      year: serializer.fromJson<int?>(json['year']),
      month: serializer.fromJson<int?>(json['month']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'year': serializer.toJson<int?>(year),
      'month': serializer.toJson<int?>(month),
    };
  }

  ExpenseMonthsViewData copyWith(
          {Value<int?> year = const Value.absent(),
          Value<int?> month = const Value.absent()}) =>
      ExpenseMonthsViewData(
        year: year.present ? year.value : this.year,
        month: month.present ? month.value : this.month,
      );
  @override
  String toString() {
    return (StringBuffer('ExpenseMonthsViewData(')
          ..write('year: $year, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(year, month);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseMonthsViewData &&
          other.year == this.year &&
          other.month == this.month);
}

class $ExpenseMonthsViewView
    extends ViewInfo<$ExpenseMonthsViewView, ExpenseMonthsViewData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$AppDatabase attachedDatabase;
  $ExpenseMonthsViewView(this.attachedDatabase, [this._alias]);
  $ExpenseTable get expenses => attachedDatabase.expense.createAlias('t0');
  @override
  List<GeneratedColumn> get $columns => [year, month];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'expense_months_view';
  @override
  Map<SqlDialect, String>? get createViewStatements => null;
  @override
  $ExpenseMonthsViewView get asDslTable => this;
  @override
  ExpenseMonthsViewData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseMonthsViewData(
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year']),
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month']),
    );
  }

  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, true,
      generatedAs: GeneratedAs(expenses.createdDate.year, false),
      type: DriftSqlType.int);
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, true,
      generatedAs: GeneratedAs(expenses.createdDate.month, false),
      type: DriftSqlType.int);
  @override
  $ExpenseMonthsViewView createAlias(String alias) {
    return $ExpenseMonthsViewView(attachedDatabase, alias);
  }

  @override
  Query? get query =>
      (attachedDatabase.selectOnly(expenses)..addColumns($columns)).join([])
        ..groupBy([year, month])
        ..orderBy([
          OrderingTerm(expression: year, mode: OrderingMode.desc),
          OrderingTerm(expression: month, mode: OrderingMode.desc)
        ]);
  @override
  Set<String> get readTables => const {'expense'};
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TagTable tag = $TagTable(this);
  late final $ExpenseTable expense = $ExpenseTable(this);
  late final $ExpenseTagTable expenseTag = $ExpenseTagTable(this);
  late final $AppSettingTable appSetting = $AppSettingTable(this);
  late final $ScheduledExpenseTable scheduledExpense =
      $ScheduledExpenseTable(this);
  late final $ScheduledExpenseTagTable scheduledExpenseTag =
      $ScheduledExpenseTagTable(this);
  late final $ExpenseListViewView expenseListView = $ExpenseListViewView(this);
  late final $ExpenseMonthSummaryViewView expenseMonthSummaryView =
      $ExpenseMonthSummaryViewView(this);
  late final $ExpenseMonthsViewView expenseMonthsView =
      $ExpenseMonthsViewView(this);
  late final Index idxTagId =
      Index('idx_tag_id', 'CREATE INDEX idx_tag_id ON expense_tag (tag_id)');
  late final Index idxExpenseId = Index('idx_expense_id',
      'CREATE INDEX idx_expense_id ON expense_tag (expense_id)');
  late final TagDao tagDao = TagDao(this as AppDatabase);
  late final ExpenseDao expenseDao = ExpenseDao(this as AppDatabase);
  late final AppSettingDao appSettingDao = AppSettingDao(this as AppDatabase);
  late final ScheduledExpenseDao scheduledExpenseDao =
      ScheduledExpenseDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        tag,
        expense,
        expenseTag,
        appSetting,
        scheduledExpense,
        scheduledExpenseTag,
        expenseListView,
        expenseMonthSummaryView,
        expenseMonthsView,
        idxTagId,
        idxExpenseId
      ];
}

typedef $$TagTableCreateCompanionBuilder = TagCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  Value<int?> color,
  required DateTime added,
  Value<bool> deleted,
});
typedef $$TagTableUpdateCompanionBuilder = TagCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<int?> color,
  Value<DateTime> added,
  Value<bool> deleted,
});

final class $$TagTableReferences
    extends BaseReferences<_$AppDatabase, $TagTable, TagData> {
  $$TagTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpenseTagTable, List<ExpenseTagData>>
      _expenseTagRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.expenseTag,
              aliasName: $_aliasNameGenerator(db.tag.id, db.expenseTag.tagId));

  $$ExpenseTagTableProcessedTableManager get expenseTagRefs {
    final manager = $$ExpenseTagTableTableManager($_db, $_db.expenseTag)
        .filter((f) => f.tagId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_expenseTagRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ScheduledExpenseTagTable,
      List<ScheduledExpenseTagData>> _scheduledExpenseTagRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.scheduledExpenseTag,
          aliasName:
              $_aliasNameGenerator(db.tag.id, db.scheduledExpenseTag.tagId));

  $$ScheduledExpenseTagTableProcessedTableManager get scheduledExpenseTagRefs {
    final manager =
        $$ScheduledExpenseTagTableTableManager($_db, $_db.scheduledExpenseTag)
            .filter((f) => f.tagId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_scheduledExpenseTagRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TagTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TagTable> {
  $$TagTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get added => $state.composableBuilder(
      column: $state.table.added,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get deleted => $state.composableBuilder(
      column: $state.table.deleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter expenseTagRefs(
      ComposableFilter Function($$ExpenseTagTableFilterComposer f) f) {
    final $$ExpenseTagTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.expenseTag,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder, parentComposers) =>
            $$ExpenseTagTableFilterComposer(ComposerState($state.db,
                $state.db.expenseTag, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter scheduledExpenseTagRefs(
      ComposableFilter Function($$ScheduledExpenseTagTableFilterComposer f) f) {
    final $$ScheduledExpenseTagTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.scheduledExpenseTag,
            getReferencedColumn: (t) => t.tagId,
            builder: (joinBuilder, parentComposers) =>
                $$ScheduledExpenseTagTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.scheduledExpenseTag,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$TagTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TagTable> {
  $$TagTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get added => $state.composableBuilder(
      column: $state.table.added,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get deleted => $state.composableBuilder(
      column: $state.table.deleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$TagTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagTable,
    TagData,
    $$TagTableFilterComposer,
    $$TagTableOrderingComposer,
    $$TagTableCreateCompanionBuilder,
    $$TagTableUpdateCompanionBuilder,
    (TagData, $$TagTableReferences),
    TagData,
    PrefetchHooks Function(
        {bool expenseTagRefs, bool scheduledExpenseTagRefs})> {
  $$TagTableTableManager(_$AppDatabase db, $TagTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$TagTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TagTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int?> color = const Value.absent(),
            Value<DateTime> added = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
          }) =>
              TagCompanion(
            id: id,
            name: name,
            description: description,
            color: color,
            added: added,
            deleted: deleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<int?> color = const Value.absent(),
            required DateTime added,
            Value<bool> deleted = const Value.absent(),
          }) =>
              TagCompanion.insert(
            id: id,
            name: name,
            description: description,
            color: color,
            added: added,
            deleted: deleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TagTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {expenseTagRefs = false, scheduledExpenseTagRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expenseTagRefs) db.expenseTag,
                if (scheduledExpenseTagRefs) db.scheduledExpenseTag
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expenseTagRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$TagTableReferences._expenseTagRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TagTableReferences(db, table, p0).expenseTagRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tagId == item.id),
                        typedResults: items),
                  if (scheduledExpenseTagRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$TagTableReferences
                            ._scheduledExpenseTagRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TagTableReferences(db, table, p0)
                                .scheduledExpenseTagRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tagId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TagTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagTable,
    TagData,
    $$TagTableFilterComposer,
    $$TagTableOrderingComposer,
    $$TagTableCreateCompanionBuilder,
    $$TagTableUpdateCompanionBuilder,
    (TagData, $$TagTableReferences),
    TagData,
    PrefetchHooks Function(
        {bool expenseTagRefs, bool scheduledExpenseTagRefs})>;
typedef $$ExpenseTableCreateCompanionBuilder = ExpenseCompanion Function({
  Value<int> id,
  required double value,
  Value<String?> details,
  required DateTime createdDate,
  Value<int?> generated,
});
typedef $$ExpenseTableUpdateCompanionBuilder = ExpenseCompanion Function({
  Value<int> id,
  Value<double> value,
  Value<String?> details,
  Value<DateTime> createdDate,
  Value<int?> generated,
});

final class $$ExpenseTableReferences
    extends BaseReferences<_$AppDatabase, $ExpenseTable, ExpenseData> {
  $$ExpenseTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpenseTagTable, List<ExpenseTagData>>
      _expenseTagRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.expenseTag,
              aliasName:
                  $_aliasNameGenerator(db.expense.id, db.expenseTag.expenseId));

  $$ExpenseTagTableProcessedTableManager get expenseTagRefs {
    final manager = $$ExpenseTagTableTableManager($_db, $_db.expenseTag)
        .filter((f) => f.expenseId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_expenseTagRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExpenseTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ExpenseTable> {
  $$ExpenseTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get details => $state.composableBuilder(
      column: $state.table.details,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdDate => $state.composableBuilder(
      column: $state.table.createdDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get generated => $state.composableBuilder(
      column: $state.table.generated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter expenseTagRefs(
      ComposableFilter Function($$ExpenseTagTableFilterComposer f) f) {
    final $$ExpenseTagTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.expenseTag,
        getReferencedColumn: (t) => t.expenseId,
        builder: (joinBuilder, parentComposers) =>
            $$ExpenseTagTableFilterComposer(ComposerState($state.db,
                $state.db.expenseTag, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ExpenseTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ExpenseTable> {
  $$ExpenseTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get details => $state.composableBuilder(
      column: $state.table.details,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdDate => $state.composableBuilder(
      column: $state.table.createdDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get generated => $state.composableBuilder(
      column: $state.table.generated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$ExpenseTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseTable,
    ExpenseData,
    $$ExpenseTableFilterComposer,
    $$ExpenseTableOrderingComposer,
    $$ExpenseTableCreateCompanionBuilder,
    $$ExpenseTableUpdateCompanionBuilder,
    (ExpenseData, $$ExpenseTableReferences),
    ExpenseData,
    PrefetchHooks Function({bool expenseTagRefs})> {
  $$ExpenseTableTableManager(_$AppDatabase db, $ExpenseTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ExpenseTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ExpenseTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
            Value<int?> generated = const Value.absent(),
          }) =>
              ExpenseCompanion(
            id: id,
            value: value,
            details: details,
            createdDate: createdDate,
            generated: generated,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double value,
            Value<String?> details = const Value.absent(),
            required DateTime createdDate,
            Value<int?> generated = const Value.absent(),
          }) =>
              ExpenseCompanion.insert(
            id: id,
            value: value,
            details: details,
            createdDate: createdDate,
            generated: generated,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ExpenseTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({expenseTagRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expenseTagRefs) db.expenseTag],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expenseTagRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ExpenseTableReferences._expenseTagRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseTableReferences(db, table, p0)
                                .expenseTagRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.expenseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExpenseTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseTable,
    ExpenseData,
    $$ExpenseTableFilterComposer,
    $$ExpenseTableOrderingComposer,
    $$ExpenseTableCreateCompanionBuilder,
    $$ExpenseTableUpdateCompanionBuilder,
    (ExpenseData, $$ExpenseTableReferences),
    ExpenseData,
    PrefetchHooks Function({bool expenseTagRefs})>;
typedef $$ExpenseTagTableCreateCompanionBuilder = ExpenseTagCompanion Function({
  required int tagId,
  required int expenseId,
  Value<int> rowid,
});
typedef $$ExpenseTagTableUpdateCompanionBuilder = ExpenseTagCompanion Function({
  Value<int> tagId,
  Value<int> expenseId,
  Value<int> rowid,
});

final class $$ExpenseTagTableReferences
    extends BaseReferences<_$AppDatabase, $ExpenseTagTable, ExpenseTagData> {
  $$ExpenseTagTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TagTable _tagIdTable(_$AppDatabase db) =>
      db.tag.createAlias($_aliasNameGenerator(db.expenseTag.tagId, db.tag.id));

  $$TagTableProcessedTableManager? get tagId {
    if ($_item.tagId == null) return null;
    final manager = $$TagTableTableManager($_db, $_db.tag)
        .filter((f) => f.id($_item.tagId!));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExpenseTable _expenseIdTable(_$AppDatabase db) =>
      db.expense.createAlias(
          $_aliasNameGenerator(db.expenseTag.expenseId, db.expense.id));

  $$ExpenseTableProcessedTableManager? get expenseId {
    if ($_item.expenseId == null) return null;
    final manager = $$ExpenseTableTableManager($_db, $_db.expense)
        .filter((f) => f.id($_item.expenseId!));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpenseTagTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ExpenseTagTable> {
  $$ExpenseTagTableFilterComposer(super.$state);
  $$TagTableFilterComposer get tagId {
    final $$TagTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $state.db.tag,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$TagTableFilterComposer(
            ComposerState(
                $state.db, $state.db.tag, joinBuilder, parentComposers)));
    return composer;
  }

  $$ExpenseTableFilterComposer get expenseId {
    final $$ExpenseTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseId,
        referencedTable: $state.db.expense,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ExpenseTableFilterComposer(
            ComposerState(
                $state.db, $state.db.expense, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ExpenseTagTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ExpenseTagTable> {
  $$ExpenseTagTableOrderingComposer(super.$state);
  $$TagTableOrderingComposer get tagId {
    final $$TagTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $state.db.tag,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$TagTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.tag, joinBuilder, parentComposers)));
    return composer;
  }

  $$ExpenseTableOrderingComposer get expenseId {
    final $$ExpenseTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseId,
        referencedTable: $state.db.expense,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ExpenseTableOrderingComposer(ComposerState(
                $state.db, $state.db.expense, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ExpenseTagTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseTagTable,
    ExpenseTagData,
    $$ExpenseTagTableFilterComposer,
    $$ExpenseTagTableOrderingComposer,
    $$ExpenseTagTableCreateCompanionBuilder,
    $$ExpenseTagTableUpdateCompanionBuilder,
    (ExpenseTagData, $$ExpenseTagTableReferences),
    ExpenseTagData,
    PrefetchHooks Function({bool tagId, bool expenseId})> {
  $$ExpenseTagTableTableManager(_$AppDatabase db, $ExpenseTagTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ExpenseTagTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ExpenseTagTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> tagId = const Value.absent(),
            Value<int> expenseId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseTagCompanion(
            tagId: tagId,
            expenseId: expenseId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int tagId,
            required int expenseId,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseTagCompanion.insert(
            tagId: tagId,
            expenseId: expenseId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseTagTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tagId = false, expenseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tagId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable:
                        $$ExpenseTagTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$ExpenseTagTableReferences._tagIdTable(db).id,
                  ) as T;
                }
                if (expenseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.expenseId,
                    referencedTable:
                        $$ExpenseTagTableReferences._expenseIdTable(db),
                    referencedColumn:
                        $$ExpenseTagTableReferences._expenseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpenseTagTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseTagTable,
    ExpenseTagData,
    $$ExpenseTagTableFilterComposer,
    $$ExpenseTagTableOrderingComposer,
    $$ExpenseTagTableCreateCompanionBuilder,
    $$ExpenseTagTableUpdateCompanionBuilder,
    (ExpenseTagData, $$ExpenseTagTableReferences),
    ExpenseTagData,
    PrefetchHooks Function({bool tagId, bool expenseId})>;
typedef $$AppSettingTableCreateCompanionBuilder = AppSettingCompanion Function({
  Value<int> key,
  Value<String?> value,
});
typedef $$AppSettingTableUpdateCompanionBuilder = AppSettingCompanion Function({
  Value<int> key,
  Value<String?> value,
});

class $$AppSettingTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AppSettingTable> {
  $$AppSettingTableFilterComposer(super.$state);
  ColumnFilters<int> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AppSettingTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AppSettingTable> {
  $$AppSettingTableOrderingComposer(super.$state);
  ColumnOrderings<int> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$AppSettingTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingTable,
    AppSettingData,
    $$AppSettingTableFilterComposer,
    $$AppSettingTableOrderingComposer,
    $$AppSettingTableCreateCompanionBuilder,
    $$AppSettingTableUpdateCompanionBuilder,
    (
      AppSettingData,
      BaseReferences<_$AppDatabase, $AppSettingTable, AppSettingData>
    ),
    AppSettingData,
    PrefetchHooks Function()> {
  $$AppSettingTableTableManager(_$AppDatabase db, $AppSettingTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AppSettingTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AppSettingTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
          }) =>
              AppSettingCompanion(
            key: key,
            value: value,
          ),
          createCompanionCallback: ({
            Value<int> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
          }) =>
              AppSettingCompanion.insert(
            key: key,
            value: value,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingTable,
    AppSettingData,
    $$AppSettingTableFilterComposer,
    $$AppSettingTableOrderingComposer,
    $$AppSettingTableCreateCompanionBuilder,
    $$AppSettingTableUpdateCompanionBuilder,
    (
      AppSettingData,
      BaseReferences<_$AppDatabase, $AppSettingTable, AppSettingData>
    ),
    AppSettingData,
    PrefetchHooks Function()>;
typedef $$ScheduledExpenseTableCreateCompanionBuilder
    = ScheduledExpenseCompanion Function({
  Value<int> id,
  required double value,
  required String details,
  required DateTime createdDate,
  required DateTime nextInsert,
  required bool repeatDaily,
  required bool repeatWeekly,
  required bool repeatMonthly,
  required bool repeatYearly,
});
typedef $$ScheduledExpenseTableUpdateCompanionBuilder
    = ScheduledExpenseCompanion Function({
  Value<int> id,
  Value<double> value,
  Value<String> details,
  Value<DateTime> createdDate,
  Value<DateTime> nextInsert,
  Value<bool> repeatDaily,
  Value<bool> repeatWeekly,
  Value<bool> repeatMonthly,
  Value<bool> repeatYearly,
});

final class $$ScheduledExpenseTableReferences extends BaseReferences<
    _$AppDatabase, $ScheduledExpenseTable, ScheduledExpenseData> {
  $$ScheduledExpenseTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ScheduledExpenseTagTable,
      List<ScheduledExpenseTagData>> _scheduledExpenseTagRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.scheduledExpenseTag,
          aliasName: $_aliasNameGenerator(db.scheduledExpense.id,
              db.scheduledExpenseTag.scheduledExpenseId));

  $$ScheduledExpenseTagTableProcessedTableManager get scheduledExpenseTagRefs {
    final manager =
        $$ScheduledExpenseTagTableTableManager($_db, $_db.scheduledExpenseTag)
            .filter((f) => f.scheduledExpenseId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_scheduledExpenseTagRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ScheduledExpenseTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ScheduledExpenseTable> {
  $$ScheduledExpenseTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get details => $state.composableBuilder(
      column: $state.table.details,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdDate => $state.composableBuilder(
      column: $state.table.createdDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get nextInsert => $state.composableBuilder(
      column: $state.table.nextInsert,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get repeatDaily => $state.composableBuilder(
      column: $state.table.repeatDaily,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get repeatWeekly => $state.composableBuilder(
      column: $state.table.repeatWeekly,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get repeatMonthly => $state.composableBuilder(
      column: $state.table.repeatMonthly,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get repeatYearly => $state.composableBuilder(
      column: $state.table.repeatYearly,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter scheduledExpenseTagRefs(
      ComposableFilter Function($$ScheduledExpenseTagTableFilterComposer f) f) {
    final $$ScheduledExpenseTagTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.scheduledExpenseTag,
            getReferencedColumn: (t) => t.scheduledExpenseId,
            builder: (joinBuilder, parentComposers) =>
                $$ScheduledExpenseTagTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.scheduledExpenseTag,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$ScheduledExpenseTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ScheduledExpenseTable> {
  $$ScheduledExpenseTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get details => $state.composableBuilder(
      column: $state.table.details,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdDate => $state.composableBuilder(
      column: $state.table.createdDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get nextInsert => $state.composableBuilder(
      column: $state.table.nextInsert,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get repeatDaily => $state.composableBuilder(
      column: $state.table.repeatDaily,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get repeatWeekly => $state.composableBuilder(
      column: $state.table.repeatWeekly,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get repeatMonthly => $state.composableBuilder(
      column: $state.table.repeatMonthly,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get repeatYearly => $state.composableBuilder(
      column: $state.table.repeatYearly,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$ScheduledExpenseTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduledExpenseTable,
    ScheduledExpenseData,
    $$ScheduledExpenseTableFilterComposer,
    $$ScheduledExpenseTableOrderingComposer,
    $$ScheduledExpenseTableCreateCompanionBuilder,
    $$ScheduledExpenseTableUpdateCompanionBuilder,
    (ScheduledExpenseData, $$ScheduledExpenseTableReferences),
    ScheduledExpenseData,
    PrefetchHooks Function({bool scheduledExpenseTagRefs})> {
  $$ScheduledExpenseTableTableManager(
      _$AppDatabase db, $ScheduledExpenseTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ScheduledExpenseTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ScheduledExpenseTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<String> details = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
            Value<DateTime> nextInsert = const Value.absent(),
            Value<bool> repeatDaily = const Value.absent(),
            Value<bool> repeatWeekly = const Value.absent(),
            Value<bool> repeatMonthly = const Value.absent(),
            Value<bool> repeatYearly = const Value.absent(),
          }) =>
              ScheduledExpenseCompanion(
            id: id,
            value: value,
            details: details,
            createdDate: createdDate,
            nextInsert: nextInsert,
            repeatDaily: repeatDaily,
            repeatWeekly: repeatWeekly,
            repeatMonthly: repeatMonthly,
            repeatYearly: repeatYearly,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double value,
            required String details,
            required DateTime createdDate,
            required DateTime nextInsert,
            required bool repeatDaily,
            required bool repeatWeekly,
            required bool repeatMonthly,
            required bool repeatYearly,
          }) =>
              ScheduledExpenseCompanion.insert(
            id: id,
            value: value,
            details: details,
            createdDate: createdDate,
            nextInsert: nextInsert,
            repeatDaily: repeatDaily,
            repeatWeekly: repeatWeekly,
            repeatMonthly: repeatMonthly,
            repeatYearly: repeatYearly,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ScheduledExpenseTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({scheduledExpenseTagRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (scheduledExpenseTagRefs) db.scheduledExpenseTag
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scheduledExpenseTagRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ScheduledExpenseTableReferences
                            ._scheduledExpenseTagRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ScheduledExpenseTableReferences(db, table, p0)
                                .scheduledExpenseTagRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.scheduledExpenseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ScheduledExpenseTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScheduledExpenseTable,
    ScheduledExpenseData,
    $$ScheduledExpenseTableFilterComposer,
    $$ScheduledExpenseTableOrderingComposer,
    $$ScheduledExpenseTableCreateCompanionBuilder,
    $$ScheduledExpenseTableUpdateCompanionBuilder,
    (ScheduledExpenseData, $$ScheduledExpenseTableReferences),
    ScheduledExpenseData,
    PrefetchHooks Function({bool scheduledExpenseTagRefs})>;
typedef $$ScheduledExpenseTagTableCreateCompanionBuilder
    = ScheduledExpenseTagCompanion Function({
  required int tagId,
  required int scheduledExpenseId,
  Value<int> rowid,
});
typedef $$ScheduledExpenseTagTableUpdateCompanionBuilder
    = ScheduledExpenseTagCompanion Function({
  Value<int> tagId,
  Value<int> scheduledExpenseId,
  Value<int> rowid,
});

final class $$ScheduledExpenseTagTableReferences extends BaseReferences<
    _$AppDatabase, $ScheduledExpenseTagTable, ScheduledExpenseTagData> {
  $$ScheduledExpenseTagTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TagTable _tagIdTable(_$AppDatabase db) => db.tag.createAlias(
      $_aliasNameGenerator(db.scheduledExpenseTag.tagId, db.tag.id));

  $$TagTableProcessedTableManager? get tagId {
    if ($_item.tagId == null) return null;
    final manager = $$TagTableTableManager($_db, $_db.tag)
        .filter((f) => f.id($_item.tagId!));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ScheduledExpenseTable _scheduledExpenseIdTable(_$AppDatabase db) =>
      db.scheduledExpense.createAlias($_aliasNameGenerator(
          db.scheduledExpenseTag.scheduledExpenseId, db.scheduledExpense.id));

  $$ScheduledExpenseTableProcessedTableManager? get scheduledExpenseId {
    if ($_item.scheduledExpenseId == null) return null;
    final manager =
        $$ScheduledExpenseTableTableManager($_db, $_db.scheduledExpense)
            .filter((f) => f.id($_item.scheduledExpenseId!));
    final item = $_typedResult.readTableOrNull(_scheduledExpenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ScheduledExpenseTagTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ScheduledExpenseTagTable> {
  $$ScheduledExpenseTagTableFilterComposer(super.$state);
  $$TagTableFilterComposer get tagId {
    final $$TagTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $state.db.tag,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$TagTableFilterComposer(
            ComposerState(
                $state.db, $state.db.tag, joinBuilder, parentComposers)));
    return composer;
  }

  $$ScheduledExpenseTableFilterComposer get scheduledExpenseId {
    final $$ScheduledExpenseTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.scheduledExpenseId,
            referencedTable: $state.db.scheduledExpense,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ScheduledExpenseTableFilterComposer(ComposerState($state.db,
                    $state.db.scheduledExpense, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ScheduledExpenseTagTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ScheduledExpenseTagTable> {
  $$ScheduledExpenseTagTableOrderingComposer(super.$state);
  $$TagTableOrderingComposer get tagId {
    final $$TagTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $state.db.tag,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$TagTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.tag, joinBuilder, parentComposers)));
    return composer;
  }

  $$ScheduledExpenseTableOrderingComposer get scheduledExpenseId {
    final $$ScheduledExpenseTableOrderingComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.scheduledExpenseId,
            referencedTable: $state.db.scheduledExpense,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ScheduledExpenseTableOrderingComposer(ComposerState($state.db,
                    $state.db.scheduledExpense, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ScheduledExpenseTagTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduledExpenseTagTable,
    ScheduledExpenseTagData,
    $$ScheduledExpenseTagTableFilterComposer,
    $$ScheduledExpenseTagTableOrderingComposer,
    $$ScheduledExpenseTagTableCreateCompanionBuilder,
    $$ScheduledExpenseTagTableUpdateCompanionBuilder,
    (ScheduledExpenseTagData, $$ScheduledExpenseTagTableReferences),
    ScheduledExpenseTagData,
    PrefetchHooks Function({bool tagId, bool scheduledExpenseId})> {
  $$ScheduledExpenseTagTableTableManager(
      _$AppDatabase db, $ScheduledExpenseTagTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ScheduledExpenseTagTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$ScheduledExpenseTagTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> tagId = const Value.absent(),
            Value<int> scheduledExpenseId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduledExpenseTagCompanion(
            tagId: tagId,
            scheduledExpenseId: scheduledExpenseId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int tagId,
            required int scheduledExpenseId,
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduledExpenseTagCompanion.insert(
            tagId: tagId,
            scheduledExpenseId: scheduledExpenseId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ScheduledExpenseTagTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tagId = false, scheduledExpenseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tagId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable:
                        $$ScheduledExpenseTagTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$ScheduledExpenseTagTableReferences._tagIdTable(db).id,
                  ) as T;
                }
                if (scheduledExpenseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.scheduledExpenseId,
                    referencedTable: $$ScheduledExpenseTagTableReferences
                        ._scheduledExpenseIdTable(db),
                    referencedColumn: $$ScheduledExpenseTagTableReferences
                        ._scheduledExpenseIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ScheduledExpenseTagTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScheduledExpenseTagTable,
    ScheduledExpenseTagData,
    $$ScheduledExpenseTagTableFilterComposer,
    $$ScheduledExpenseTagTableOrderingComposer,
    $$ScheduledExpenseTagTableCreateCompanionBuilder,
    $$ScheduledExpenseTagTableUpdateCompanionBuilder,
    (ScheduledExpenseTagData, $$ScheduledExpenseTagTableReferences),
    ScheduledExpenseTagData,
    PrefetchHooks Function({bool tagId, bool scheduledExpenseId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TagTableTableManager get tag => $$TagTableTableManager(_db, _db.tag);
  $$ExpenseTableTableManager get expense =>
      $$ExpenseTableTableManager(_db, _db.expense);
  $$ExpenseTagTableTableManager get expenseTag =>
      $$ExpenseTagTableTableManager(_db, _db.expenseTag);
  $$AppSettingTableTableManager get appSetting =>
      $$AppSettingTableTableManager(_db, _db.appSetting);
  $$ScheduledExpenseTableTableManager get scheduledExpense =>
      $$ScheduledExpenseTableTableManager(_db, _db.scheduledExpense);
  $$ScheduledExpenseTagTableTableManager get scheduledExpenseTag =>
      $$ScheduledExpenseTagTableTableManager(_db, _db.scheduledExpenseTag);
}
