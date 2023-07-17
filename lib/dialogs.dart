import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Dialogs {
  // this dialog pops up when there are no definitions for the word provided
  static Future<void> showNoDefinitions(
      BuildContext context, String word) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'No Definitions Found',
            ),
            content: Text(
              "No definitions found for \“${word.trim()}\” on the Dictionary API server. If the word exists as spelled, then the word is not in this dictionary.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'No Definitions Found',
          ),
          content: Text(
            "No definitions found for \“${word.trim()}\” on the Dictionary API server. If the word exists as spelled, then the word is not in this dictionary.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // this dialog pops up when the user presses and there is a network issue
  static Future<void> showNetworkIssues(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'Network Issue',
            ),
            content: Text(
              "A network issue exists either in the server or on your device. Please check your network settings and try again.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'Network Issue',
          ),
          content: Text(
            "A network issue exists either in the server or on your device. Please check your network settings and try again.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // this dialog pops up when the user presses there is a network issue
  static Future<void> showInputIssue(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'Invalid Input',
            ),
            content: Text(
              "Please limit your search term to consist of letters from the English alphabet, i.e., discard any number, emoji or punctuation mark.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'Invalid Input',
          ),
          content: Text(
            "Please limit your search term to consist of letters from the English alphabet, i.e., discard any number, emoji or punctuation mark.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
