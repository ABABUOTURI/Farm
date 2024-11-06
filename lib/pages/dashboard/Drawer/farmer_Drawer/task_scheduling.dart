import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SupervisorTaskSchedulingPage extends StatefulWidget {
  @override
  _SupervisorTaskSchedulingPageState createState() => _SupervisorTaskSchedulingPageState();
}

class _SupervisorTaskSchedulingPageState extends State<SupervisorTaskSchedulingPage> {
  List<Map<String, dynamic>> tasks = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.event_note, size: 28), // Task icon in AppBar
            SizedBox(width: 8),
            Text('Task Scheduling'),
          ],
        ),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCalendar(),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showAddTaskDialog(),
              icon: Icon(Icons.add), // Add task icon for button
              label: Text('Add New Task'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskCard(tasks[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _selectedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.task_alt), // Task icon for each task item
        title: Text(task['title']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assigned To: ${task['assignedTo']}'),
            Text('Priority: ${task['priority']}'),
            Text('Due Date: ${task['dueDate']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue), // Edit icon
              onPressed: () => _showEditTaskDialog(task),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red), // Delete icon
              onPressed: () => _deleteTask(task),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    _showTaskDialog();
  }

  void _showEditTaskDialog(Map<String, dynamic> task) {
    _showTaskDialog(task: task);
  }

  void _showTaskDialog({Map<String, dynamic>? task}) {
    final titleController = TextEditingController(text: task?['title']);
    final assignedToController = TextEditingController(text: task?['assignedTo']);
    final priorityController = TextEditingController(text: task?['priority']);
    final dueDateController = TextEditingController(text: task?['dueDate']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Add New Task' : 'Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Task Title'),
                ),
                TextField(
                  controller: assignedToController,
                  decoration: InputDecoration(labelText: 'Assigned To'),
                ),
                TextField(
                  controller: priorityController,
                  decoration: InputDecoration(labelText: 'Priority (High/Medium/Low)'),
                ),
                TextField(
                  controller: dueDateController,
                  decoration: InputDecoration(labelText: 'Due Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (task == null) {
                  _addTask(
                    titleController.text,
                    assignedToController.text,
                    priorityController.text,
                    dueDateController.text,
                  );
                } else {
                  _updateTask(
                    task,
                    titleController.text,
                    assignedToController.text,
                    priorityController.text,
                    dueDateController.text,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(task == null ? 'Add' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addTask(String title, String assignedTo, String priority, String dueDate) {
    setState(() {
      tasks.add({
        'title': title,
        'assignedTo': assignedTo,
        'priority': priority,
        'dueDate': dueDate,
      });
    });
  }

  void _updateTask(Map<String, dynamic> task, String title, String assignedTo, String priority, String dueDate) {
    setState(() {
      task['title'] = title;
      task['assignedTo'] = assignedTo;
      task['priority'] = priority;
      task['dueDate'] = dueDate;
    });
  }

  void _deleteTask(Map<String, dynamic> task) {
    setState(() {
      tasks.remove(task);
    });
  }
}
