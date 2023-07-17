// Async function which gets device details for analytics
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:WordDefiner/Analytics/device_form.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<DeviceForm> deviceDetails() async {
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String appVersion = '';

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  try {
    appVersion = packageInfo.version;
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
  return DeviceForm(deviceName, deviceVersion, identifier, appVersion);
}
