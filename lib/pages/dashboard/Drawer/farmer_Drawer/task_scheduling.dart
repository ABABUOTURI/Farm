import 'package:farm_system_inventory/models/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskSchedulingPage extends StatefulWidget {
  @override
  _TaskSchedulingPageState createState() => _TaskSchedulingPageState();
}

class _TaskSchedulingPageState extends State<TaskSchedulingPage> {
  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasksBox'); // Assuming 'tasksBox' is the name used in main.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Scheduling'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Task Assignment Section
              Text(
                'Task Assignment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: taskBox.listenable(),
                builder: (context, Box<Task> box, _) {
                  if (box.isEmpty) {
                    return Center(child: Text('No tasks available'));
                  }
                  return Column(
                    children: box.values.map((task) => _buildTaskCard(task)).toList(),
                  );
                },
              ),
              SizedBox(height: 20),

              // Calendar View Section (Placeholder)
              Text(
                'Scheduled Tasks (Calendar View)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    'Calendar View Coming Soon!',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Notifications and Alerts Section (Static for now)
              Text(
                'Notifications & Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildNotificationCard('Upcoming Task', 'Planting scheduled for tomorrow'),
              _buildNotificationCard('Alert', 'High-priority harvesting due next week'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(), // Add new task
        backgroundColor: Color(0xFF08B797),
        child: Icon(Icons.add),
      ),
    );
  }

  // Method to build task card with a consistent width
  Widget _buildTaskCard(Task task) {
    return SizedBox(
      width: double.infinity, // Ensures the card takes full width
      child: Dismissible(
        key: Key(task.key.toString()), // Use task key as unique identifier
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) {
          task.delete(); // Delete task from Hive
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task deleted')));
        },
        child: Card(
          elevation: 2,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.task,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(task.description),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Priority: ${task.priority}',
                      style: TextStyle(color: Colors.orange),
                    ),
                    TextButton(
                      onPressed: () => _showTaskDialog(task: task), // Edit task
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Color(0xFF08B797)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build notification card with a consistent width
  Widget _buildNotificationCard(String title, String message) {
    return SizedBox(
      width: double.infinity, // Ensures the card takes full width
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialog to create or edit a task
  void _showTaskDialog({Task? task}) {
    final TextEditingController taskController = TextEditingController(text: task?.task ?? '');
    final TextEditingController descriptionController = TextEditingController(text: task?.description ?? '');
    final TextEditingController priorityController = TextEditingController(text: task?.priority ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task == null ? 'Add New Task' : 'Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(labelText: 'Priority'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTask = Task(
                task: taskController.text,
                description: descriptionController.text,
                priority: priorityController.text,
              );

              if (task == null) {
                // Add new task
                taskBox.add(newTask);
              } else {
                // Update existing task
                task.task = taskController.text;
                task.description = descriptionController.text;
                task.priority = priorityController.text;
                task.save();
              }

              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(task == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}
