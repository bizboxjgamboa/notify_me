import 'package:flutter/services.dart';

class DeviceInstallationService {
  static const deviceInstallation =
      MethodChannel('com.bizbox.notifyme/deviceinstallation');
  static const String getDeviceIdChannelMethod = "getDeviceId";
  static const String getDeviceTokenChannelMethod = "getDeviceToken";
  static const String getDevicePlatformChannelMethod = "getDevicePlatform";

  Future<String> getDeviceId() async {
    final dynamic deviceId =
        await deviceInstallation.invokeMethod(getDeviceIdChannelMethod);
    return deviceId as String;
  }

  Future<String> getDeviceToken() async {
    final dynamic deviceToken =
        await deviceInstallation.invokeMethod(getDeviceTokenChannelMethod);
    return deviceToken as String;
  }

  Future<String> getDevicePlatform() async {
    final dynamic devicePlatform =
        await deviceInstallation.invokeMethod(getDevicePlatformChannelMethod);
    return devicePlatform as String;
  }
}
