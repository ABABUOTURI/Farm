import 'package:farm_system_inventory/models/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SupervisorTaskSchedulingPage extends StatefulWidget {
  @override
  _SupervisorTaskSchedulingPageState createState() =>
      _SupervisorTaskSchedulingPageState();
}

class _SupervisorTaskSchedulingPageState
    extends State<SupervisorTaskSchedulingPage> {
  late Box<Task> taskBox;
  String _selectedPriority = 'All';

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskAssignedToController =
      TextEditingController();
  final TextEditingController _taskDueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Hive.initFlutter();
    _openTaskBox();
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskAssignedToController.dispose();
    _taskDueDateController.dispose();
    super.dispose();
  }

  // Open Hive box to store and retrieve tasks
  Future<void> _openTaskBox() async {
    taskBox = await Hive.openBox<Task>('taskBox');
    setState(() {});
  }

  // Add new task
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
      taskBox.add(newTask);  // Add task to Hive box
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
    List<Task> filteredTasks = taskBox.values.toList();

    if (_selectedPriority != 'All') {
      filteredTasks = filteredTasks
          .where((task) => task.priority == _selectedPriority)
          .toList();
    }

    filteredTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    return filteredTasks;
  }

  // Build task card for display
  Widget _buildTaskCard(Task task, int index) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text('${task.title}, Assigned to: ${task.assignedTo}'),
        subtitle: Text('Due: ${task.dueDate}, Priority: ${task.priority}'),
      ),
    );
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
              Text(
                'Scheduled Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: ValueListenableBuilder(
                  valueListenable: taskBox.listenable(),
                  builder: (context, Box<Task> box, _) {
                    return ListView.builder(
                      itemCount: _getFilteredTasks().length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(_getFilteredTasks()[index], index);
                      },
                    );
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
            child: Icon(Icons.priority_high),
            tooltip: 'Low Priority',
          ),
        ],
      ),
    );
  }

  // Build the form to add a new task
  Widget _buildTaskForm() {
    return Column(
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
          decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
          keyboardType: TextInputType.datetime,
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedPriority,
          items: ['All', 'High', 'Low']
              .map((String priority) =>
                  DropdownMenuItem(value: priority, child: Text(priority)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedPriority = value!;
            });
          },
          decoration: InputDecoration(labelText: 'Priority'),
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
