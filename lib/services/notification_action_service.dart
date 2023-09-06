import 'package:flutter/services.dart';
import 'dart:async';
import 'package:notify_me/models/notify_me_action.dart';

class NotificationActionService {
  static const notificationAction =
      MethodChannel('com.bizbox.notifyme/notificationaction');
  static const String triggerActionChannelMethod = "triggerAction";
  static const String getLaunchActionChannelMethod = "getLaunchAction";

  final actionMappings = {
    'action_a': NotifyMeAction.actionA,
    'action_b': NotifyMeAction.actionB
  };

  final actionTriggeredController = StreamController.broadcast();

  NotificationActionService() {
    notificationAction.setMethodCallHandler(handleNotificationActionCall);
  }

  Stream get actionTriggered => actionTriggeredController.stream;

  Future<void> triggerAction({required String action}) async {
    if (!actionMappings.containsKey(action)) {
      return;
    }

    actionTriggeredController.add(actionMappings[action]);
  }

  Future<void> checkLaunchAction() async {
    final launchAction = await notificationAction
        .invokeMethod(getLaunchActionChannelMethod) as String?;

    if (launchAction != null) {
      triggerAction(action: launchAction);
    }
  }

  Future<void> handleNotificationActionCall(MethodCall call) async {
    switch (call.method) {
      case triggerActionChannelMethod:
        return triggerAction(action: call.arguments as String);
      default:
        throw MissingPluginException();
    }
  }
}
