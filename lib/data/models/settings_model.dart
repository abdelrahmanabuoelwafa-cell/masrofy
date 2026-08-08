import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class SettingsModel extends HiveObject {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  late double monthlyBudget;

  @HiveField(2)
  late bool darkMode;

  @HiveField(3)
  late String userName;

  @HiveField(4)
  late DateTime createdAt;

  SettingsModel({
    this.monthlyBudget = 5000.0,
    this.darkMode = false,
    this.userName = 'صديقي',
  }) {
    createdAt = DateTime.now();
  }

  SettingsModel copyWith({
    double? monthlyBudget,
    bool? darkMode,
    String? userName,
  }) {
    return SettingsModel(
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      darkMode: darkMode ?? this.darkMode,
      userName: userName ?? this.userName,
    )..id = id;
  }
}
