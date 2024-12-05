import 'package:hive/hive.dart';

part 'task.g.dart'; // Hive type adapter generation


@HiveType(typeId: 6)
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String assignedTo;

  @HiveField(2)
  final String priority;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final String task;  // You can expand the task field if needed

  // Additional fields for task status and description
  @HiveField(5)
  var status;

  @HiveField(6)
  var description;

  Task({
    required this.title,
    required this.assignedTo,
    required this.priority,
    required this.dueDate,
    this.task = 'Default Task', // Default task value
    this.status = 'Pending',  // Default status
    this.description = '',    // Default description
  });

  // Method to convert Task to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'assignedTo': assignedTo,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'task': task,
      'status': status,
      'description': description,
    };
  }

  // Factory to convert a map back to Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      assignedTo: map['assignedTo'],
      priority: map['priority'],
      dueDate: DateTime.parse(map['dueDate']),
      task: map['task'] ?? 'Default Task',
      status: map['status'] ?? 'Pending',
      description: map['description'] ?? '',
    );
  }
}
