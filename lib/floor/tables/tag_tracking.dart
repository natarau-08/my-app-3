
import 'package:floor/floor.dart';

@Entity(
  tableName: 'tag_tracking',
  indices: [
    Index(value: ['name'], unique: true)
  ]
)
class TagTracking {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'tag_id')
  int tagId;

  @ColumnInfo(name: 'starting_date')
  DateTime startingDate;

  @ColumnInfo(name: 'pinned')
  bool pinned;

  @ColumnInfo(name: 'name')
  String name;

  @ColumnInfo(name: 'description')
  String description;

  @ColumnInfo(name: 'created_date')
  DateTime createdDate;

  TagTracking({
    this.id,
    required this.tagId,
    required this.startingDate,
    required this.pinned,
    required this.name,
    required this.description,
    required this.createdDate
  });
}