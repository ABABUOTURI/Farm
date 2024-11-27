import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';

class SupervisorTaskSchedulingPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onTaskAdded;

  SupervisorTaskSchedulingPage({required this.onTaskAdded});

  @override
  _SupervisorTaskSchedulingPageState createState() =>
      _SupervisorTaskSchedulingPageState();
}

class _SupervisorTaskSchedulingPageState extends State<SupervisorTaskSchedulingPage> {
  List<Map<String, dynamic>> tasks = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  late Box taskBox;

  @override
  void initState() {
    super.initState();
    _initializeHive(); // Initialize Hive box
  }

  // Initialize Hive box
  _initializeHive() async {
    taskBox = await Hive.openBox('tasks'); // Open or create 'tasks' box
    _loadTasks(); // Load tasks from Hive
  }

  // Load tasks from Hive
  _loadTasks() {
    setState(() {
      tasks = List<Map<String, dynamic>>.from(taskBox.values);
    });
  }

  // Save tasks to Hive
  _saveTasks() {
    taskBox.clear(); // Clear existing tasks in Hive
    for (var task in tasks) {
      taskBox.add(task); // Add new tasks to Hive
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.event_note, size: 28),
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
              icon: Icon(Icons.add),
              label: Text('Add New Task'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskCard(tasks[index], index);
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

  // Create card for each task
  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(Icons.task_alt, color: Colors.blue),
        title: Text(
          task['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditTaskDialog(task, index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(index),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    _showTaskDialog();
  }

  void _showEditTaskDialog(Map<String, dynamic> task, int index) {
    _showTaskDialog(task: task, index: index);
  }

  void _showTaskDialog({Map<String, dynamic>? task, int? index}) {
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
                    index!,
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
    final newTask = {
      'title': title,
      'assignedTo': assignedTo,
      'priority': priority,
      'dueDate': dueDate,
    };

    widget.onTaskAdded(newTask); // Send task back to parent widget

    setState(() {
      tasks.add(newTask); // Optionally update local state as well
    });

    _saveTasks(); // Save updated tasks to Hive

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task successfully added!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _updateTask(int index, String title, String assignedTo, String priority, String dueDate) {
    setState(() {
      tasks[index] = {
        'title': title,
        'assignedTo': assignedTo,
        'priority': priority,
        'dueDate': dueDate,
      };
    });

    _saveTasks(); // Save updated tasks to Hive
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });

    _saveTasks(); // Save updated tasks to Hive

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task deleted!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
