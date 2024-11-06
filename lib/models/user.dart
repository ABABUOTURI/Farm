import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3) // Ensure this typeId is unique across your app
class User extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String phoneNumber;

  @HiveField(4)
  String password;

  @HiveField(5)
  String role;

  @HiveField(6)
  String farmName;

  @HiveField(7)
  String location;

  @HiveField(8)
  String name; // Combines the "name" field from the second model
  
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
    required this.farmName,
    required this.location,
    required this.name,
  });
}
