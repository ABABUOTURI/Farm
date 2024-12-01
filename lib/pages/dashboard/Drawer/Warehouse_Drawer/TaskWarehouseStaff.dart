import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WarehouseStaffTaskSchedulingPage extends StatefulWidget {
  @override
  _WarehouseStaffTaskSchedulingPageState createState() => _WarehouseStaffTaskSchedulingPageState();
}

class _WarehouseStaffTaskSchedulingPageState extends State<WarehouseStaffTaskSchedulingPage> {
  List<Task> tasks = [];

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _editTask(int index, Task task) {
    setState(() {
      tasks[index] = task;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Scheduling'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scheduled Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                itemCount: tasks.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildTaskCard(tasks[index], index);
                },
              ),
              SizedBox(height: 20),

              // Add Task Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskPage(
                          onAddTask: _addTask,
                        ),
                      ),
                    );
                  },
                  child: Text('Add Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08B797),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Assigned to: ${task.assignedTo}'),
            Text('Priority: ${task.priority}'),
            Text('Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Edit Task Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskPage(
                          task: task,
                          index: index,
                          onEditTask: _editTask,
                        ),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteTask(index);
                    _showNotification('Task deleted successfully!');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Task Model
class Task {
  String title;
  String assignedTo;
  String priority;
  DateTime dueDate;

  Task({
    required this.title,
    required this.assignedTo,
    required this.priority,
    required this.dueDate,
  });

  get date => null;
}

// Placeholder for Add Task Page
class AddTaskPage extends StatelessWidget {
  final Function(Task) onAddTask;

  AddTaskPage({required this.onAddTask});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController assignedToController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  DateTime dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              decoration: InputDecoration(labelText: 'Priority'),
            ),
            SizedBox(height: 10),
            Text('Due Date: ${DateFormat('yyyy-MM-dd').format(dueDate)}'),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != dueDate) {
                  dueDate = picked;
                }
              },
              child: Text('Select Due Date'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final task = Task(
                    title: titleController.text,
                    assignedTo: assignedToController.text,
                    priority: priorityController.text,
                    dueDate: dueDate,
                  );
                  onAddTask(task);
                  Navigator.pop(context);
                },
                child: Text('Add Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF08B797),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Edit Task Page
class EditTaskPage extends StatelessWidget {
  final Task task;
  final int index;
  final Function(int, Task) onEditTask;

  EditTaskPage({required this.task, required this.index, required this.onEditTask});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController assignedToController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = task.title;
    assignedToController.text = task.assignedTo;
    priorityController.text = task.priority;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              decoration: InputDecoration(labelText: 'Priority'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final updatedTask = Task(
                    title: titleController.text,
                    assignedTo: assignedToController.text,
                    priority: priorityController.text,
                    dueDate: task.dueDate, // Assuming you want to keep the same due date
                  );
                  onEditTask(index, updatedTask);
                  Navigator.pop(context);
                },
                child: Text('Update Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF08B797),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
