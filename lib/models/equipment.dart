import 'package:hive/hive.dart';

part 'equipment.g.dart';

@HiveType(typeId: 5)
class Equipment extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  String model;

  @HiveField(3)
  String serialNumber;

  @HiveField(4)
  DateTime lastMaintenance;

  var availability;

  Equipment({
    required this.name,
    required this.description,
    required this.model,
    required this.serialNumber,
    required this.lastMaintenance, required String availability,
  });
}
