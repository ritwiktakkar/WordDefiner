import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:WordDefiner/Analytics/constants.dart' as Constants;

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
            CupertinoButton(
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
              "A network issue exists either in the servers or on your device. Please check your network settings and try again.",
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
            "A network issue exists either in the servers or on your device. Please check your network settings and try again.",
          ),
          actions: <Widget>[
            CupertinoButton(
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
              "Please limit your search term to consist of letters from the English alphabet and without spaces, i.e., discard any number, emoji or punctuation mark. Additionally, please ensure that your search term is less than 50 characters.",
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
            "Please limit your search term to consist of letters from the English alphabet and without spaces, i.e., discard any number, emoji or punctuation mark. Additionally, please ensure that your search term is less than 50 characters.",
          ),
          actions: <Widget>[
            CupertinoButton(
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

  // this dialog pops up when the user inputs a word that is not in the list
  static Future<void> showInvalidWord(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'Unrecognized Word',
            ),
            content: Text(
              "Are you sure this word exists as spelled? This app doesn't recognize it.",
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
            'Unrecognized Word',
          ),
          content: Text(
            "Are you sure this word exists as spelled? This app doesn't recognize it.",
          ),
          actions: <Widget>[
            CupertinoButton(
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

  static Future<void> showContactDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          if (Platform.isAndroid) {
            return AlertDialog(
              title: const Text("Thanks for using WordDefiner!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog first
                      Future.delayed(const Duration(milliseconds: 300), () {
                        launchUrl(Uri.parse(Constants.twitterUrl),
                            mode: LaunchMode.externalApplication);
                      });
                    },
                    child: const Text('Follow me on Twitter / X'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog first
                      Future.delayed(const Duration(milliseconds: 300), () {
                        launchUrl(Uri.parse(Constants.myWebsite),
                            mode: LaunchMode.externalApplication);
                      });
                    },
                    child: const Text('Visit my website'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog first
                      Future.delayed(const Duration(milliseconds: 300), () {
                        launchUrl(Uri.parse(Constants.formUrl));
                      });
                    },
                    child: const Text('Provide feedback'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Dismiss dialog first
                      await Share.share(
                          "Try the lightweight, powerful, and free English dictionary, thesaurus, and rhyming words app, WordDefiner: " +
                              (Platform.isAndroid
                                  ? Constants.worddefinerURLAndroid
                                  : Constants.worddefinerURLApple));
                    },
                    child: const Text('Share WordDefiner'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: const Text("Thanks for using WordDefiner!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog first
                      Future.delayed(const Duration(milliseconds: 300), () {
                        launchUrl(Uri.parse(Constants.twitterUrl),
                            mode: LaunchMode.externalApplication);
                      });
                    },
                    child: const Text('Follow me on Twitter / X'),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog first
                      Future.delayed(const Duration(milliseconds: 300), () {
                        launchUrl(Uri.parse(Constants.myWebsite),
                            mode: LaunchMode.externalApplication);
                      });
                    },
                    child: const Text('Visit my website'),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog first
                      Future.delayed(const Duration(milliseconds: 300), () {
                        launchUrl(Uri.parse(Constants.formUrl));
                      });
                    },
                    child: const Text('Provide feedback'),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Dismiss dialog first
                      await Share.share(
                          "Try the lightweight, powerful, and free English dictionary, thesaurus, and rhyming words app, WordDefiner: " +
                              (Platform.isAndroid
                                  ? Constants.worddefinerURLAndroid
                                  : Constants.worddefinerURLApple));
                    },
                    child: const Text('Share WordDefiner'),
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          }
        });
  }
}
