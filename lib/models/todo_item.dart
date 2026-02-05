class TodoItem {
  String title;
  String time;
  bool isCompleted;

  TodoItem({
    required this.title,
    required this.time,
    this.isCompleted = false,
  });
}
