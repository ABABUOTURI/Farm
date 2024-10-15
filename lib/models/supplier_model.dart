import 'package:hive/hive.dart';

part 'supplier_model.g.dart'; // This is the generated file

@HiveType(typeId: 0)
class Supplier {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String contact;

  @HiveField(2)
  final String products;

  @HiveField(3)
  final String performance;

  Supplier({required this.name, required this.contact, required this.products, required this.performance});
}
