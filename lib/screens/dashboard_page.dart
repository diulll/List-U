import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../models/due_item.dart';
import '../models/note_item.dart';
import 'due_list_page.dart';
import 'notes_list_page.dart';

class DashboardPage extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  const DashboardPage({super.key, this.userName, this.userEmail});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  List<TodoItem> upcomingTodos = [];
  List<DueItem> dueItems = [];
  List<NoteItem> noteItems = [];

  @override
  Widget build(BuildContext context) {
    String displayName = widget.userName ?? 'User';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF2D3B48)),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF2D3B48)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Greeting
                Text(
                  'Hey $displayName',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "what's your plan?",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3B48),
                  ),
                ),
                const SizedBox(height: 25),
                // Category buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryButton('Personal', const Color(0xFF38F9D7)),
                    _buildCategoryButton('Work', const Color(0xFF43E97B)),
                    _buildCategoryButton('Shopping', const Color(0xFFFFB6B6)),
                    _buildCategoryButton('Movies to watch', const Color(0xFFB19CD9)),
                  ],
                ),
                const SizedBox(height: 30),
                // Upcoming To-dos
                const Text(
                  "Upcoming To-do's",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3B48),
                  ),
                ),
                const SizedBox(height: 15),
                (upcomingTodos.isEmpty && dueItems.isEmpty)
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'No upcoming to-dos',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          ...upcomingTodos.map((todo) {
                            return _buildTodoItem(
                              todo.title,
                              todo.time,
                              todo.isCompleted,
                              () {
                                setState(() {
                                  todo.isCompleted = !todo.isCompleted;
                                });
                              },
                            );
                          }).toList(),
                          ...dueItems.map((due) {
                            return _buildTodoItem(
                              due.title,
                              due.dueDate,
                              false,
                              () {},
                            );
                          }).toList(),
                        ],
                      ),
                const SizedBox(height: 25),
                // Due's Section
                _buildSectionHeader("Due's", Icons.event_note, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DueListPage(
                        dueItems: dueItems,
                        onUpdate: (items) {
                          setState(() {
                            dueItems = items;
                          });
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                // Notes Section
                _buildSectionHeader('Notes', Icons.note_alt_outlined, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesListPage(
                        noteItems: noteItems,
                        onUpdate: (items) {
                          setState(() {
                            noteItems = items;
                          });
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                // History Section
                _buildSectionHeader('History', Icons.history, () {}),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 0),
                _buildNavItem(Icons.bar_chart, 1),
                _buildAddButton(),
                _buildNavItem(Icons.calendar_today_outlined, 3),
                _buildNavItem(Icons.settings_outlined, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTodoItem(String title, String time, bool isCompleted, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? const Color(0xFF43E97B) : Colors.grey[300]!,
                  width: 2,
                ),
                color: isCompleted ? const Color(0xFF43E97B) : Colors.transparent,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isCompleted ? Colors.grey[400] : const Color(0xFF2D3B48),
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey[300], size: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF43E97B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF43E97B),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3B48),
                ),
              ),
            ],
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      child: Icon(
        icon,
        size: 26,
        color: isSelected ? const Color(0xFF43E97B) : Colors.grey[400],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        _showAddOptionsBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF43E97B).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          size: 26,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Add New',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3B48),
              ),
            ),
            const SizedBox(height: 25),
            _buildOptionTile(
              icon: Icons.event_note,
              title: "Due's",
              subtitle: 'Add new due item',
              color: const Color(0xFF43E97B),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DueListPage(
                      dueItems: dueItems,
                      onUpdate: (items) {
                        setState(() {
                          dueItems = items;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            _buildOptionTile(
              icon: Icons.note_alt_outlined,
              title: 'Notes',
              subtitle: 'Add new note',
              color: const Color(0xFFE056FD),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotesListPage(
                      noteItems: noteItems,
                      onUpdate: (items) {
                        setState(() {
                          noteItems = items;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3B48),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
