import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:studysecretary_alpha/DatabaseHelper.dart';

class NotificationService {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  NotificationService(this.notificationsPlugin);

  Future<void> showMotivationalNotification() async {
    final data = await dbHelper.fetchRandomMessageAndGoal();
    final message = data['message'] ?? 'Stay motivated!';
    final goal = data['goal'] ?? 'Set your goals and achieve them!';

    const androidDetails = AndroidNotificationDetails(
      'motivation_channel',
      'Motivational Notifications',
      channelDescription: 'Displays motivational messages and goals',
      importance: Importance.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0, // Notification ID
      message,
      goal,
      notificationDetails,
    );
  }
}
