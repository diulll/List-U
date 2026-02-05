class DueItem {
  String title;
  String dueDate;
  String priority;

  DueItem({
    required this.title,
    required this.dueDate,
    this.priority = 'Medium',
  });
}
