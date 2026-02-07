import 'package:hive/hive.dart';

part 'todo_item.g.dart';

@HiveType(typeId: 2)
class TodoItem extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String time;

  @HiveField(2)
  bool isCompleted;

  TodoItem({required this.title, required this.time, this.isCompleted = false});
}
