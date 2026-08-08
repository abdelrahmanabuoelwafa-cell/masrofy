import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 2)
class NotificationModel extends HiveObject {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String message;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late bool isRead;

  @HiveField(5)
  String type; // 'warning', 'info', 'success'

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
    this.type = 'warning',
  });

  NotificationModel copyWith({
    String? title,
    String? message,
    DateTime? date,
    bool? isRead,
    String? type,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    )..id = id;
  }
}
