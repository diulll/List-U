import 'package:hive/hive.dart';

part 'due_item.g.dart';

@HiveType(typeId: 1)
class DueItem extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String dueDate;

  @HiveField(2)
  String priority;

  @HiveField(3)
  bool isCompleted;

  DueItem({
    required this.title,
    required this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
  });
}
