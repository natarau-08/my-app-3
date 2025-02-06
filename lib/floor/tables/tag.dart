
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

@Entity(
  tableName: 'tags',
  indices: [
    Index(value: ['name'], unique: true)
  ]
)
class Tag {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'name')
  String name;

  @ColumnInfo(name: 'description')
  String? description;

  @ColumnInfo(name: 'color')
  Color? color;

  @ColumnInfo(name: 'added_time')
  DateTime added;

  @ColumnInfo(name: 'deleted')
  bool deleted;

  Tag({
    this.id,
    required this.name,
    this.description,
    this.color,
    required this.added,
    this.deleted = false
  });
}