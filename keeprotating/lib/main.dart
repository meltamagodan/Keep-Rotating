import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:keeprotating/notification_controller.dart';
import 'package:root/root.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: 'group',
      channelKey: 'channelKey',
      channelName: 'channelName',
      channelDescription: 'channelDescription',
    )
  ], channelGroups: [
    NotificationChannelGroup(channelGroupKey: 'group', channelGroupName: 'channelGroupName')
  ]);

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _status = false;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
    );
    checkRoot();
  }

  //Check Root status
  Future<void> checkRoot() async {
    bool? result = await Root.isRooted();
    setState(() {
      _status = result!;
    });
  }

  void runService() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'channelKey',
        title: 'Wanna Rotate?',
        actionType: ActionType.KeepOnTop,
        category: NotificationCategory.Service,
        locked: true,
        autoDismissible: false,
      ),
      actionButtons: [
        NotificationActionButton(
          key: '0',
          label: 'Portrait',
          autoDismissible: false, // Keeps the notification
          actionType: ActionType.KeepOnTop,
        ),
        NotificationActionButton(
          key: '1',
          label: 'Landscape',
          autoDismissible: false,
          actionType: ActionType.KeepOnTop,
        ),
        NotificationActionButton(
          key: '2',
          label: 'RevLandscape',
          autoDismissible: false,
          actionType: ActionType.KeepOnTop,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withBlue(30),
      appBar: AppBar(
        title: const Text('Keep Rotating', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black.withBlue(40),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 60.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Root Access: ',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Text(
                _status ? "Granted!" : "Denied!",
                style: TextStyle(
                  fontSize: 20.0,
                  color: _status ? Colors.green : Colors.red,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
            onPressed: () async {
              runService();
            },
            child: const Text('Start Service'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'Note: Force close the app to close the service.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            barrierColor: Colors.white.withOpacity(0.1),
            context: context,
            builder: (BuildContext context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Set the border radius
                  ),
                  backgroundColor: Colors.black.withOpacity(0.9),
                  title: const Text(
                    'Keep Rotating',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Just keep rotating DON\'T STOP!',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Version: 1.0z',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Made by: ',
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (!await launchUrl(Uri.http("github.com", "/meltamagodan/Keep-Rotating"))) {
                                  Future.error("Couldn't open the link!");
                                }
                              },
                              child: const Text(
                                'NEON',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}
