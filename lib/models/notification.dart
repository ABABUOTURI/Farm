import 'package:hive/hive.dart';

part 'notification.g.dart'; // Needed for code generation

@HiveType(typeId: 1) // Unique typeId for the model
class NotificationModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String message;

  @HiveField(2)
  DateTime date;

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
  });
}
