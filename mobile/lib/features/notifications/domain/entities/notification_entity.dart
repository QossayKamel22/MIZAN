import 'package:equatable/equatable.dart';

enum NotificationType { billReminder, budgetAlert, aiInsight, goalMilestone, accountActivity }

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.deepLink,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? deepLink;

  NotificationEntity copyWithRead(bool read) => NotificationEntity(
        id: id,
        type: type,
        title: title,
        body: body,
        createdAt: createdAt,
        isRead: read,
        deepLink: deepLink,
      );

  @override
  List<Object?> get props => [id, type, title, body, createdAt, isRead];
}
