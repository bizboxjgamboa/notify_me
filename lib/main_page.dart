import 'package:flutter/material.dart';
import 'package:notify_me/services/notification_registration_service.dart';
import 'config.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  final notificationRegistrationService = NotificationRegistrationService(
      Config.backendServiceEndpoint, Config.apiKey);

  bool isNewsChecked = false;
  bool isNewsSportChecked = false;
  List<String> tags = [];

  void registerButtonClicked() async {
    try {
      PermissionStatus status = await Permission.notification.status;

      if (!status.isGranted) {
        bool shouldShowRationale =
            await Permission.notification.shouldShowRequestRationale;

        if (shouldShowRationale) {
          PermissionStatus newStatus = await Permission.notification.request();
          if (!newStatus.isGranted) {
            return;
          }
        } else {
          await showNotificationAccessRequiredAlert(
            message:
                "To enable notifications, go to app settings and allow notifications.",
          );
          return;
        }
      }

      await notificationRegistrationService.registerDevice(tags);
      await showActionAlert(message: "Device registered");
      setState(() {
        tags = [];
      });
    } catch (e) {
      await showActionAlert(message: e.toString());
    }
  }

  void deregisterButtonClicked() async {
    try {
      await notificationRegistrationService.deregisterDevice();
      await showActionAlert(message: "Device deregistered");
    } catch (e) {
      await showActionAlert(message: e.toString());
    }
  }

  Future<void> showNotificationAccessRequiredAlert(
      {required String message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification Access Required'),
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Go to Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showActionAlert({required String message}) async {
    await showDialog<void>(
      context: context,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isNewsChecked,
                  onChanged: (newValue) {
                    setState(() {
                      isNewsChecked = newValue!;
                      if (isNewsChecked) {
                        tags.add("news");
                      } else {
                        tags.remove("news");
                      }
                    });
                  },
                ),
                const Text("News"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isNewsSportChecked,
                  onChanged: (newValue) {
                    setState(() {
                      isNewsSportChecked = newValue!;
                      if (isNewsSportChecked) {
                        tags.add("news:sports");
                      } else {
                        tags.remove("news:sports");
                      }
                    });
                  },
                ),
                const Text("News about sports"),
              ],
            ),
            TextButton(
              onPressed: registerButtonClicked,
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: deregisterButtonClicked,
              child: const Text("Deregister"),
            ),
          ],
        ),
      ),
    );
  }
}
