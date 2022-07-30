import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs {
  // this dialog pops up when the user presses the 'paste' button and there's no URL to paste in the clipboard
  static Future<void> showNothingToPaste(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'No URL To Paste',
          ),
          content: Text(
            "This app can only paste valid URLs stored in the clipboard. Please make sure your clipboard only contains a valid URL before pressing the 'Paste' button.",
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

  // this dialog pops up when the user presses the 'copy' button and there's nothing to copy to the clipboard
  static Future<void> showNothingToCopy(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'No URL To Copy',
          ),
          content: Text(
            "Your output field contains no shortened URL to copy to the clipboard. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field.",
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

  // this dialog pops up when the user presses the 'shorten URL' button and the api returns an error
  static Future<void> showShorteningURLError(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Couldn\'t Shorten URL',
          ),
          content: Text(
            "The input field does not seem to contain a valid URL. Therefore, it can't be shortened. Please make sure your entry contains a valid URL and try again.",
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

  // this dialog pops up when the user presses the 'share url' button and there's nothing to share
  static Future<void> showNothingToShare(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Invalid Entry',
          ),
          content: Text(
            "Your output field contains no shortened URL to share. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field.",
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

  // this dialog pops up when the user presses the 'shorten url' button and the input field doesn't contain a URL
  static Future<void> showInvalidInput(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Invalid Entry',
          ),
          content: Text(
            "The input field does not seem to contain a valid URL. Therefore, it can't be shortened. Please make sure your entry contains a valid URL and try again.",
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

  // this dialog pops up when the user presses the 'shorten url' button and there is no internet
  static Future<void> showNoInternetConnection(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'No Internet Connection',
          ),
          content: Text(
            "Your device doesn't seem to have an internet connection. Please check your network settings and try again.",
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
