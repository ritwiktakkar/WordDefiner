// Async function which gets device details for analytics
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:worddefiner/Analytics/device_form.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<DeviceForm> deviceDetails() async {
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String appBuildNumber = '';

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  try {
    appBuildNumber = packageInfo.buildNumber;
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;

      deviceName = androidInfo.model;
      deviceVersion = androidInfo.version.release;
      identifier = androidInfo.fingerprint;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;

      deviceName = iosInfo.modelName;
      deviceVersion = iosInfo.systemVersion;
      identifier = iosInfo.identifierForVendor.toString();
    } else if (Platform.isMacOS) {
      var macInfo = await deviceInfoPlugin.macOsInfo;

      deviceName = macInfo.modelName;
      deviceVersion = macInfo.osRelease;
      identifier = macInfo.systemGUID.toString();
    } else if (Platform.isLinux) {
      var linuxInfo = await deviceInfoPlugin.linuxInfo;

      deviceName = linuxInfo.id;
      deviceVersion = linuxInfo.prettyName;
      identifier = linuxInfo.machineId.toString();
    }
  } on PlatformException {
    debugPrint('Failed to get platform version');
  }
  return DeviceForm(deviceName, deviceVersion, identifier, appBuildNumber);
}
