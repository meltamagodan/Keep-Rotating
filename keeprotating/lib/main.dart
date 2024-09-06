import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:keeprotating/notification_controller.dart';
import 'package:root/root.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'channelKey',
      channelName: 'Service Notification',
      channelDescription: 'Service Notification',
    )
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
        showWhen: false,
        backgroundColor: Colors.lightBlueAccent,
      ),
      actionButtons: [
        NotificationActionButton(
          key: '0',
          label: 'Portrait',
          autoDismissible: false,
          actionType: ActionType.KeepOnTop,
        ),
        NotificationActionButton(
          key: '1',
          label: 'Landscape',
          autoDismissible: false,
          actionType: ActionType.KeepOnTop,
        ),
        NotificationActionButton(
          key: '3',
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
                  color: _status ? Colors.green : Colors.red,fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
            onPressed: () async {
              runService();
            },
            child: const Text('Start Service',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,),),
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
        backgroundColor: Colors.blueAccent,
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
                          'Version: 1.0.1-z',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Made by: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(Uri.http("github.com", "/meltamagodan/Keep-Rotating"));
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
        child: const Icon(Icons.info_outline,color: Colors.white,),
      ),
    );
  }
}
