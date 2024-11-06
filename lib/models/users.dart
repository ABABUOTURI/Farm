// models/user.dart
import 'package:hive/hive.dart';

part 'users.g.dart'; // This will be generated later

@HiveType(typeId: 4)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String role;

  User({
    required this.name,
    required this.email,
    required this.role,
  });
}
