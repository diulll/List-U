import 'package:flutter/material.dart';
import '../models/due_item.dart';
import 'add_due_page.dart';

class DueListPage extends StatefulWidget {
  final List<DueItem> dueItems;
  final Function(List<DueItem>) onUpdate;

  const DueListPage({
    super.key,
    required this.dueItems,
    required this.onUpdate,
  });

  @override
  State<DueListPage> createState() => _DueListPageState();
}

class _DueListPageState extends State<DueListPage> {
  late List<DueItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.dueItems);
  }

  void _addNewDue() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDuePage(),
      ),
    );

    if (result != null && result is DueItem) {
      setState(() {
        _items.add(result);
      });
      widget.onUpdate(_items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3B48)),
          onPressed: () {
            widget.onUpdate(_items);
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Due's",
          style: TextStyle(
            color: Color(0xFF2D3B48),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text(
                    'No due items yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return _buildDueCard(item, index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDue,
        backgroundColor: const Color(0xFF43E97B),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDueCard(DueItem item, int index) {
    Color priorityColor;
    switch (item.priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Low':
        priorityColor = Colors.blue;
        break;
      default:
        priorityColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3B48),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 5),
                    Text(
                      item.dueDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.priority,
                        style: TextStyle(
                          fontSize: 10,
                          color: priorityColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                _items.removeAt(index);
              });
              widget.onUpdate(_items);
            },
          ),
        ],
      ),
    );
  }
}
