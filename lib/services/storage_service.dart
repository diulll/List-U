import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_item.dart';
import '../models/due_item.dart';
import '../models/todo_item.dart';

class StorageService {
  static const String noteBoxName = 'notes';
  static const String dueBoxName = 'dues';
  static const String todoBoxName = 'todos';

  static late Box<NoteItem> noteBox;
  static late Box<DueItem> dueBox;
  static late Box<TodoItem> todoBox;

  /// Initialize Hive and open all boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(NoteItemAdapter());
    Hive.registerAdapter(DueItemAdapter());
    Hive.registerAdapter(TodoItemAdapter());

    // Open boxes
    noteBox = await Hive.openBox<NoteItem>(noteBoxName);
    dueBox = await Hive.openBox<DueItem>(dueBoxName);
    todoBox = await Hive.openBox<TodoItem>(todoBoxName);
  }

  // ===== NOTES =====
  static List<NoteItem> getAllNotes() {
    return noteBox.values.toList();
  }

  static Future<void> addNote(NoteItem note) async {
    await noteBox.add(note);
  }

  static Future<void> deleteNote(int index) async {
    await noteBox.deleteAt(index);
  }

  static Future<void> updateNote(int index, NoteItem note) async {
    await noteBox.putAt(index, note);
  }

  // ===== DUES =====
  static List<DueItem> getAllDues() {
    return dueBox.values.toList();
  }

  static Future<void> addDue(DueItem due) async {
    await dueBox.add(due);
  }

  static Future<void> deleteDue(int index) async {
    await dueBox.deleteAt(index);
  }

  static Future<void> updateDue(int index, DueItem due) async {
    await dueBox.putAt(index, due);
  }

  // ===== TODOS =====
  static List<TodoItem> getAllTodos() {
    return todoBox.values.toList();
  }

  static Future<void> addTodo(TodoItem todo) async {
    await todoBox.add(todo);
  }

  static Future<void> deleteTodo(int index) async {
    await todoBox.deleteAt(index);
  }

  static Future<void> updateTodo(int index, TodoItem todo) async {
    await todoBox.putAt(index, todo);
  }
}
