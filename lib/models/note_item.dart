import 'package:hive/hive.dart';

part 'note_item.g.dart';

@HiveType(typeId: 0)
class NoteItem extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  String date;

  NoteItem({required this.title, required this.content, required this.date});
}
