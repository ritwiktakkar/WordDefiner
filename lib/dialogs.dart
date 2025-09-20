import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:package_info_plus/package_info_plus.dart';

final inAppReview = InAppReview.instance;
String appVersion = '';
String appBuildNumber = '';

class Dialogs {
  // this function is used to initialize the app version and build version
  static Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    appVersion = info.version;
    appBuildNumber = info.buildNumber;
  }

  // this dialog pops up when there are no definitions for the word provided
  static Future<AlertButton> showNoDefinitions(BuildContext context) async {
    return FlutterPlatformAlert.showAlert(
      windowTitle: 'No definitions found',
      text: 'No definitions found for the word',
      alertStyle: AlertButtonStyle.ok,
      windowPosition: AlertWindowPosition.parentWindowCenter,
    );
  }

  // this dialog pops up when the user presses and there is a network issue
  static Future<AlertButton> showNetworkIssues(BuildContext context) async {
    return FlutterPlatformAlert.showAlert(
      windowTitle: 'Network issue',
      text: 'A network issue exists either in the servers or on your device',
      alertStyle: AlertButtonStyle.ok,
      windowPosition: AlertWindowPosition.parentWindowCenter,
    );
  }

  // this dialog pops up when the user presses there is a network issue
  static Future<AlertButton> showInputIssue(BuildContext context) async {
    return FlutterPlatformAlert.showAlert(
      windowTitle: 'Invalid input',
      text:
          'Your search term must contain only letters from the English alphabet, no spaces, and no special characters',
      alertStyle: AlertButtonStyle.ok,
      windowPosition: AlertWindowPosition.parentWindowCenter,
    );
  }

  // this dialog pops up when the user inputs a word that is not in the list
  static Future<AlertButton> showUnrecognizedWord(BuildContext context) async {
    return FlutterPlatformAlert.showAlert(
      windowTitle: 'Unrecognized word',
      text: 'Are you sure this word exists as spelled?',
      alertStyle: AlertButtonStyle.yesNo,
      windowPosition: AlertWindowPosition.parentWindowCenter,
    );
  }

  // this dialog pops up when the user presses the menu button
  static Future<CustomButton> showMenu(BuildContext context) async {
    return FlutterPlatformAlert.showCustomAlert(
      windowTitle:
          'Thanks for using WordDefiner on ${Platform.isAndroid ? 'Android' : 'iOS'}',
      text:
          'Version $appVersion ($appBuildNumber)\n\u00A9 2022–${DateTime.now().year.toString()} RT (rickytakkar.com)',
      windowPosition: AlertWindowPosition.parentWindowCenter,
      positiveButtonTitle: 'Provide Feedback',
      negativeButtonTitle:
          (Platform.isAndroid) ? 'Rate on Play Store' : "Rate on App Store",
      neutralButtonTitle: 'Dismiss',
    );
  }

  // this dialog pops up when the user presses the more button
  static Future<CustomButton> showMoreApps(BuildContext context) async {
    return FlutterPlatformAlert.showCustomAlert(
      windowTitle: 'Glad you\'re enjoying WordDefiner',
      text:
          'Check out my other apps on the ${Platform.isAndroid ? 'Play' : 'App'} Store',
      windowPosition: AlertWindowPosition.parentWindowCenter,
      positiveButtonTitle: 'Dismiss',
      negativeButtonTitle: Platform.isAndroid ? 'Play Store' : 'App Store',
      neutralButtonTitle: '',
    );
  }

  // this dialog pops up when the user presses the menu button on Linux
  static Future<CustomButton> showMenuComputer(BuildContext context) async {
    return FlutterPlatformAlert.showCustomAlert(
      windowTitle:
          'Thanks for using WordDefiner on ${Platform.isMacOS ? 'macOS' : 'Linux'}',
      text:
          'Version $appVersion ($appBuildNumber)\n\u00A9 2022–${DateTime.now().year.toString()} RT (rickytakkar.com)',
      windowPosition: AlertWindowPosition.parentWindowCenter,
      positiveButtonTitle: 'Provide Feedback',
      negativeButtonTitle: 'Dismiss',
      neutralButtonTitle: "View GitHub",
    );
  }

  // this dialog pops up when the user presses the smartphone button on Linux
  static Future<CustomButton> showSmartphoneMenu(BuildContext context) async {
    return FlutterPlatformAlert.showCustomAlert(
      windowTitle: 'Get WordDefiner for iOS/Android',
      text: 'Select which store you use',
      windowPosition: AlertWindowPosition.parentWindowCenter,
      positiveButtonTitle: 'App Store',
      negativeButtonTitle: 'Dismiss',
      neutralButtonTitle: 'Play Store',
    );
  }
}
