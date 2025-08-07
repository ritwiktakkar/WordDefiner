import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

final inAppReview = InAppReview.instance;

class Dialogs {
  // this dialog pops up when there are no definitions for the word provided
  static Future<AlertButton> showNoDefinitions(BuildContext context) async {
    return FlutterPlatformAlert.showAlert(
      windowTitle: 'No Definitions Found',
      text: 'No definitions found for the word.',
      alertStyle: AlertButtonStyle.ok,
      windowPosition: AlertWindowPosition.screenCenter,
    );
  }

  // this dialog pops up when the user presses and there is a network issue
  static Future<AlertButton> showNetworkIssues(BuildContext context) async {
    return FlutterPlatformAlert.showAlert(
      windowTitle: 'Network Issue',
      text:
          'A network issue exists either in the servers or on your device. Please check your network settings and try again.',
      alertStyle: AlertButtonStyle.ok,
      windowPosition: AlertWindowPosition.screenCenter,
    );
  }

  // this dialog pops up when the user presses there is a network issue
  static Future<AlertButton> showInputIssue(BuildContext context) async {
    return FlutterPlatformAlert.showAlert(
      windowTitle: 'Invalid Input',
      text:
          'Please limit your search term to consist of letters from the English alphabet and without spaces. This means you should discard any numbers, emojis, or punctuation marks. Additionally, please ensure that your search term is less than 50 characters.',
      alertStyle: AlertButtonStyle.ok,
      windowPosition: AlertWindowPosition.screenCenter,
    );
  }

  // this dialog pops up when the user inputs a word that is not in the list
  static Future<AlertButton> showUnrecognizedWord(BuildContext context) async {
    return FlutterPlatformAlert.showAlert(
      windowTitle: 'Unrecognized Word',
      text: 'Are you sure this word exists as spelled?',
      alertStyle: AlertButtonStyle.yesNo,
      windowPosition: AlertWindowPosition.screenCenter,
    );
  }

  // this dialog pops up when the user presses the menu button
  static Future<CustomButton> showMenu(BuildContext context) async {
    return FlutterPlatformAlert.showCustomAlert(
      windowTitle: 'Thanks',
      text: 'for using WordDefiner',
      windowPosition: AlertWindowPosition.screenCenter,
      positiveButtonTitle: 'Provide Feedback',
      negativeButtonTitle: 'Dismiss',
      neutralButtonTitle:
          (Platform.isAndroid) ? 'Rate on Play Store' : "Rate on App Store",
    );
  }
}
