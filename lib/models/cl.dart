import 'package:hive/hive.dart';

part 'cl.g.dart';

@HiveType(typeId: 7)
class Crop {
  @HiveField(0)
  String name;

  @HiveField(1)
  String plantingDate;

  @HiveField(2)
  String harvestingDate;

  Crop({required this.name, required this.plantingDate, required this.harvestingDate});
}

@HiveType(typeId: 8)
class Livestock {
  @HiveField(0)
  String name;

  @HiveField(1)
  String breed;

  @HiveField(2)
  String feedingSchedule;

  Livestock({required this.name, required this.breed, required this.feedingSchedule});
}
