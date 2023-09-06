import 'package:flutter/material.dart';
import 'package:notify_me/models/notify_me_action.dart';
import 'package:notify_me/services/notification_action_service.dart';
import 'package:notify_me/main_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final notificationActionService = NotificationActionService();

Future<void> showActionAlert({required String message}) async {
  return showDialog<void>(
    context: navigatorKey.currentState!.overlay!.context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Notify Me'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(message),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void notificationActionTriggered(NotifyMeAction action) {
  showActionAlert(
      message: "${action.toString().split(".")[1]} action received");
}

void main() async {
  runApp(const MainApp());
  notificationActionService.actionTriggered.listen((event) {
    notificationActionTriggered(event as NotifyMeAction);
  });
  await notificationActionService.checkLaunchAction();
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notify Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
      navigatorKey: navigatorKey,
    );
  }
}
