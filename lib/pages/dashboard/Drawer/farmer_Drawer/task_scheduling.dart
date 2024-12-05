import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  String id;
  String title;
  String assignedTo;
  String priority;
  DateTime dueDate;

  Task({
    this.id = '',
    required this.title,
    required this.assignedTo,
    required this.priority,
    required this.dueDate,
  });

  // Convert a Firestore document to a Task instance
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Task(
      id: doc.id,
      title: data['title'],
      assignedTo: data['assignedTo'],
      priority: data['priority'],
      dueDate: DateTime.parse(data['dueDate']),
    );
  }

  // Convert Task to a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'assignedTo': assignedTo,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
    };
  }
}

class SupervisorTaskSchedulingPage extends StatefulWidget {
  const SupervisorTaskSchedulingPage({super.key});

  @override
  _SupervisorTaskSchedulingPageState createState() =>
      _SupervisorTaskSchedulingPageState();
}

class _SupervisorTaskSchedulingPageState
    extends State<SupervisorTaskSchedulingPage> {
  String _selectedPriority = 'All';

  // Controllers for form inputs
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskAssignedToController =
      TextEditingController();
  final TextEditingController _taskDueDateController = TextEditingController();

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskAssignedToController.dispose();
    _taskDueDateController.dispose();
    super.dispose();
  }

  // Method to add a new task
  void _addTask() async {
    String taskTitle = _taskTitleController.text.trim();
    String taskAssignedTo = _taskAssignedToController.text.trim();
    DateTime? taskDueDate = DateTime.tryParse(_taskDueDateController.text);

    if (taskTitle.isNotEmpty &&
        taskAssignedTo.isNotEmpty &&
        taskDueDate != null) {
      Task newTask = Task(
        title: taskTitle,
        assignedTo: taskAssignedTo,
        priority: _selectedPriority,
        dueDate: taskDueDate,
      );

      try {
        // Save the task to Firestore
        await FirebaseFirestore.instance
            .collection('tasks')
            .add(newTask.toMap());
        _clearInputFields();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid task details.')),
      );
    }
  }

  // Method to clear input fields after adding a task
  void _clearInputFields() {
    _taskTitleController.clear();
    _taskAssignedToController.clear();
    _taskDueDateController.clear();
    setState(() {
      _selectedPriority = 'All';
    });
  }

  // Filter and sort tasks
  List<Task> _getFilteredTasks(List<Task> tasks) {
    List<Task> filteredTasks = tasks;

    if (_selectedPriority != 'All') {
      filteredTasks = filteredTasks
          .where((task) => task.priority == _selectedPriority)
          .toList();
    }

    filteredTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    return filteredTasks;
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
              // Title for Task List
              Text(
                'Scheduled Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Scrollable List for Tasks
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .orderBy('dueDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<Task> tasks = snapshot.data!.docs
                      .map((doc) => Task.fromFirestore(doc))
                      .toList();

                  return Container(
                    height: 300,
                    child: ListView.builder(
                      itemCount: _getFilteredTasks(tasks).length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(
                            _getFilteredTasks(tasks)[index], index);
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Add New Task',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildTaskForm(),
            ],
          ),
        ),
      ),
      // Floating Action Buttons for Filtering Options
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectedPriority = 'High';
              });
            },
            backgroundColor: _selectedPriority == 'High'
                ? Color(0xFF08B797)
                : Colors.grey[300],
            child: Icon(Icons.priority_high),
            tooltip: 'High Priority',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectedPriority = 'Low';
              });
            },
            backgroundColor: _selectedPriority == 'Low'
                ? Color(0xFF08B797)
                : Colors.grey[300],
            child: Icon(Icons.low_priority),
            tooltip: 'Low Priority',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectedPriority = 'All';
              });
            },
            backgroundColor: _selectedPriority == 'All'
                ? Color(0xFF08B797)
                : Colors.grey[300],
            child: Icon(Icons.select_all),
            tooltip: 'All',
          ),
        ],
      ),
    );
  }

  // Method to build task card with edit and delete options
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
                          onEditTask: (updatedTask) {
                            // Save changes to Firestore
                            FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(task.id)
                                .update(updatedTask.toMap());
                          },
                        ),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Delete task from Firestore
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(task.id)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task deleted successfully!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Form to add a new task
  Widget _buildTaskForm() {
    return Column(
      children: [
        TextField(
          controller: _taskTitleController,
          decoration: InputDecoration(
            labelText: 'Task Title',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _taskAssignedToController,
          decoration: InputDecoration(
            labelText: 'Assigned To',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _taskDueDateController,
          decoration: InputDecoration(
            labelText: 'Due Date (yyyy-MM-dd)',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _addTask,
          child: Text('Add Task'),
        ),
      ],
    );
  }
}

class EditTaskPage extends StatelessWidget {
  final Task task;
  final Function(Task) onEditTask;

  EditTaskPage({required this.task, required this.onEditTask});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: task.title);
    TextEditingController assignedToController =
        TextEditingController(text: task.assignedTo);
    TextEditingController dueDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(task.dueDate));

    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              controller: dueDateController,
              decoration: InputDecoration(labelText: 'Due Date (yyyy-MM-dd)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Task updatedTask = Task(
                  id: task.id,
                  title: titleController.text,
                  assignedTo: assignedToController.text,
                  priority: task.priority,
                  dueDate: DateTime.parse(dueDateController.text),
                );
                onEditTask(updatedTask);
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
