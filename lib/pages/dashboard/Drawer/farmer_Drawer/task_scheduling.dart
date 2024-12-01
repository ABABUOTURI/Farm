import 'package:farm_system_inventory/models/task.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Ensure you import Hive Flutter
import 'package:table_calendar/table_calendar.dart';
import 'models/task.dart'; // Import your Task model

class SupervisorTaskSchedulingPage extends StatefulWidget {
  @override
  _SupervisorTaskSchedulingPageState createState() =>
      _SupervisorTaskSchedulingPageState();
}

class _SupervisorTaskSchedulingPageState
    extends State<SupervisorTaskSchedulingPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  late Box<Task> taskBox;

  // Controllers for task input fields
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskAssignedToController =
      TextEditingController();
  final TextEditingController _taskPriorityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeHive(); // Initialize Hive database
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter(); // Initialize Hive
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter()); // Register the adapter for Task
    }
    taskBox = await Hive.openBox<Task>('tasksBox'); // Open tasks Hive box
    _logAllTasks(); // Log all existing tasks to the console
    setState(() {}); // Refresh UI
  }

  // Add a new task to the Hive database
  void _addTask() {
    String taskTitle = _taskTitleController.text.trim();
    String assignedTo = _taskAssignedToController.text.trim();
    String priority = _taskPriorityController.text.trim();

    if (taskTitle.isNotEmpty && assignedTo.isNotEmpty && priority.isNotEmpty) {
      Task newTask = Task(
        title: taskTitle,
        assignedTo: assignedTo,
        priority: priority,
        date: _selectedDay,
      );

      taskBox.add(newTask); // Save the task to Hive
      _logAllTasks(); // Log the newly added task
      _clearInputFields(); // Clear input fields after adding
      setState(() {}); // Refresh the UI
    } else {
      _showSnackBar('Please fill in all task details.');
    }
  }

  // Clear input fields
  void _clearInputFields() {
    _taskTitleController.clear();
    _taskAssignedToController.clear();
    _taskPriorityController.clear();
  }

  // Display a Snackbar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Show a dialog to add a new task
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskTitleController,
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: _taskAssignedToController,
                decoration: InputDecoration(labelText: 'Assigned To'),
              ),
              TextField(
                controller: _taskPriorityController,
                decoration: InputDecoration(labelText: 'Priority'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Add Task'),
              onPressed: () {
                _addTask(); // Add the task
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Log all tasks in the console
  void _logAllTasks() {
    if (taskBox.isEmpty) {
      print('No tasks in Hive.');
    } else {
      print('All tasks in Hive:');
      for (int i = 0; i < taskBox.length; i++) {
        print('Task $i: ${taskBox.getAt(i)}');
      }
    }
  }

  // Build task list widget
  Widget _buildTaskList() {
    return ValueListenableBuilder(
      valueListenable: taskBox.listenable(),
      builder: (context, Box<Task> box, _) {
        if (box.isEmpty) {
          return Center(child: Text('No tasks available.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: box.length,
          itemBuilder: (context, index) {
            // Retrieve task with fallback to default values if null
            Task task = box.getAt(index) ??
                Task(
                  title: 'No Title',
                  assignedTo: '',
                  priority: '',
                  date: DateTime.now(), // Fallback default value for date
                );

            return _buildTaskCard(task);
          },
        );
      },
    );
  }

  // Build each task card widget
  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.task_alt, color: Colors.blue),
        title: Text(
          task.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assigned To: ${task.assignedTo}'),
            Text('Priority: ${task.priority}'),
            Text('Date: ${task.date.toLocal()}'),
          ],
        ),
      ),
    );
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
            _buildCalendar(), // Calendar widget
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showAddTaskDialog,
              icon: Icon(Icons.add),
              label: Text('Add New Task'),
            ),
            SizedBox(height: 20),
            Expanded(child: _buildTaskList()), // Display task list
          ],
        ),
      ),
    );
  }

  // Build calendar widget
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
}
