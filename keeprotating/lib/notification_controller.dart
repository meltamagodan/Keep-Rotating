import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:root/root.dart';

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    switch (receivedAction.buttonKeyPressed) {
      case '0':
        await Root.exec(cmd: 'wm set-user-rotation lock 0');
        break;
      case '1':
        await Root.exec(cmd: 'wm set-user-rotation lock 1');
        break;
      case '2':
        await Root.exec(cmd: 'wm set-user-rotation lock 3');
        break;
    }
  }
}
