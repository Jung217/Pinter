import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

/// Code from: https://legacy-community.flutterflow.io/c/community-custom-widgets/local-notification-scheduled-repeatedly-or-not
Future scheduleNotification(int id, String title, TimeOfDay? t, String body,
    bool repeat, DateTime? dt) async {
  String localTimeZone =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      // 'resource://drawable/res_app_icon',
      null,
      [
        NotificationChannel(
            channelGroupKey: 'scheduled_channel_group',
            channelKey: 'scheduled',
            channelName: 'Scheduled notifications',
            channelDescription: 'Notification channel for scheduled tests',
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'scheduled_channel_group',
            channelGroupName: 'Scheduled group')
      ],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // TODO: Dialog for notification permission
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'scheduled',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: repeat
          ? NotificationCalendar(
              // Repeating notifications need only hour & minute
              hour: t!.hour,
              minute: t.minute,
              second: 00,
              timeZone: localTimeZone,
              preciseAlarm: false,
              repeats: true)
          : NotificationCalendar(
              // Non repeating notifications require year, month, day, etc...
              year: dt!.year,
              month: dt.month,
              day: dt.day,
              hour: dt.hour,
              minute: dt.minute,
              second: 00,
              timeZone: localTimeZone,
              preciseAlarm: false,
              repeats: false));
}

Future<void> cancelAllNotifications() async {
  await AwesomeNotifications().cancelAll();
}

Future<void> cancelNotification(int id) async {
  await AwesomeNotifications().cancel(id);
}
