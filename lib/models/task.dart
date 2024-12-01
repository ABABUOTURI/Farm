import 'package:hive/hive.dart';

part 'task.g.dart'; // This part is required for Hive type adapter generation

@HiveType(typeId: 6)
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String assignedTo;

  @HiveField(2)
  final String priority;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String task;

  var dueDate;

  var status;

  var description;

  Task({
    required this.title,
    required this.assignedTo,
    required this.priority,
    required this.date,
    this.task = 'Default Task', // Provide a default value for 'task'
  });

  // Method to convert Task to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'assignedTo': assignedTo,
      'priority': priority,
      'date': date.toIso8601String(),
      'task': task,
    };
  }

  // Factory to convert a map back to Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      assignedTo: map['assignedTo'],
      priority: map['priority'],
      date: DateTime.parse(map['date']),
      task: map['task'] ?? 'Default Task', // Default task value
    );
  }
}
