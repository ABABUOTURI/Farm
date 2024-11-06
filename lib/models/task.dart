import 'package:hive/hive.dart';

part 'task.g.dart'; // Needed for code generation

@HiveType(typeId: 2) // Unique typeId for the model
class Task extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  String description;

  @HiveField(2)
  String priority;

  @HiveField(3)
  List<String> assignedTo; // IDs or names of users assigned to the task

  Task({
    required this.task,
    required this.description,
    required this.priority,
    this.assignedTo = const [],
  });
}
