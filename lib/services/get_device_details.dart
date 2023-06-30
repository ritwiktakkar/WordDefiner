// Async function which gets device details for analytics
import 'dart:io';

import 'package:WordDefiner/Analytics/device_form.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<DeviceForm> deviceDetails() async {
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;

      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.androidId;

      //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;

      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor;
    }
  } on PlatformException {
    debugPrint('Failed to get platform version');
  }
  debugPrint('Device Name: $deviceName\n'
      'Device Version: $deviceVersion\n'
      'Device Identifier: $identifier');
  return DeviceForm(deviceName, deviceVersion, identifier);
}
