import 'package:hive/hive.dart';

part 'inventory_item.g.dart';

@HiveType(typeId: 4)
class InventoryItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  String unit;

  @HiveField(3)
  String type;

  var price;

  var category; // consumable or non-consumable

  InventoryItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.type,
  });
}
