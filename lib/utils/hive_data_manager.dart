import 'package:hive/hive.dart';

class HiveDataManager {
  static Future<String> getUserName() async {
    var box = Hive.box('userBox');
    return box.get('userName', defaultValue: 'Guest');
  }

  static Future<Map<String, String>> getMetricsData() async {
    var metricsBox = Hive.box('metricsBox');
    return {
      'inventory': metricsBox.get('inventory', defaultValue: 'No data available'),
      'taskCompletionRate': metricsBox.get('taskCompletionRate', defaultValue: 'No data available'),
      'upcomingTasks': metricsBox.get('upcomingTasks', defaultValue: 'No data available'),
    };
  }

  static Future<Map<String, String>> getAlertsData() async {
    var alertsBox = Hive.box('alertsBox');
    return {
      'lowStock': alertsBox.get('lowStock', defaultValue: 'No alerts'),
      'overdueTasks': alertsBox.get('overdueTasks', defaultValue: 'No alerts'),
      'maintenanceDue': alertsBox.get('maintenanceDue', defaultValue: 'No alerts'),
    };
  }
}
