import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SupervisorTaskSchedulingPage extends StatefulWidget {
  @override
  _SupervisorTaskSchedulingPageState createState() =>
      _SupervisorTaskSchedulingPageState();
}

class _SupervisorTaskSchedulingPageState
    extends State<SupervisorTaskSchedulingPage> {
  List<Task> tasks = [];
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
  void _addTask() {
    String taskTitle = _taskTitleController.text.trim();
    String taskAssignedTo = _taskAssignedToController.text.trim();
    DateTime? taskDueDate = DateTime.tryParse(_taskDueDateController.text);

    if (taskTitle.isNotEmpty && taskAssignedTo.isNotEmpty && taskDueDate != null) {
      Task newTask = Task(
        title: taskTitle,
        assignedTo: taskAssignedTo,
        priority: _selectedPriority,
        dueDate: taskDueDate,
      );
      setState(() {
        tasks.add(newTask);
      });
      _clearInputFields();
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
    _selectedPriority = 'All';
  }

  // Filter and sort tasks
  List<Task> _getFilteredTasks() {
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
              Container(
                height: 300,
                child: ListView.builder(
                  itemCount: _getFilteredTasks().length,
                  itemBuilder: (context, index) {
                    return _buildTaskCard(_getFilteredTasks()[index], index);
                  },
                ),
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
                          index: index,
                          onEditTask: (updatedTask) {
                            setState(() {
                              tasks[index] = updatedTask;
                            });
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
                    setState(() {
                      tasks.removeAt(index);
                    });
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
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: 'Due Date (YYYY-MM-DD)',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedPriority,
          items: ['High', 'Low', 'All']
              .map((String priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  ))
              .toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedPriority = newValue!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Priority',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addTask,
          child: Text('Add Task'),
        ),
      ],
    );
  }
}

class Task {
  final String title;
  final String assignedTo;
  final String priority;
  final DateTime dueDate;

  Task({
    required this.title,
    required this.assignedTo,
    required this.priority,
    required this.dueDate,
  });
}

class EditTaskPage extends StatelessWidget {
  final Task task;
  final int index;
  final Function(Task) onEditTask;

  const EditTaskPage({
    required this.task,
    required this.index,
    required this.onEditTask,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _taskTitleController =
        TextEditingController(text: task.title);
    final TextEditingController _taskAssignedToController =
        TextEditingController(text: task.assignedTo);
    final TextEditingController _taskDueDateController =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(task.dueDate));

    String _priority = task.priority;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskTitleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _taskAssignedToController,
              decoration: InputDecoration(labelText: 'Assigned To'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _taskDueDateController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(labelText: 'Due Date'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _priority,
              items: ['High', 'Low']
                  .map((String priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ))
                  .toList(),
              onChanged: (newValue) {
                _priority = newValue!;
              },
              decoration: InputDecoration(labelText: 'Priority'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Task updatedTask = Task(
                  title: _taskTitleController.text,
                  assignedTo: _taskAssignedToController.text,
                  priority: _priority,
                  dueDate: DateTime.parse(_taskDueDateController.text),
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
