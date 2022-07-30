import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iDefine/definition_model.dart' as definition_model;
import 'package:iDefine/api_requests.dart' as API;
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';
import 'package:iDefine/dialogs.dart';
import 'package:share/share.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug banner from top left
      theme:
          ThemeData(fontFamily: DefaultTextStyle.of(context).style.fontFamily),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<definition_model.iDefinition> iDefinition;

  // Create a text controller and use it to retrieve the current value of the TextField.
  final inputController = TextEditingController();

  // final ScrollController _scrollController =
  //     ScrollController(initialScrollOffset: 50.0);

  String wordToDefine;
  definition_model.iDefinition definition;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black, // make background color black
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
              ),
              child: CupertinoSearchTextField(
                placeholder: 'Search',
                controller: inputController,
                onChanged: (String value) {
                  debugPrint('The text has changed to: $value');
                },
                onSubmitted: (String value) {
                  debugPrint('Submitted text: $value');
                },
                style: TextStyle(
                  color: CupertinoColors.white,
                ),
                itemColor: CupertinoColors.inactiveGray,
              ),
            ),
            Expanded(
              child: RawScrollbar(
                thumbColor: CupertinoColors.systemGrey,
                thickness: 4,
                radius: Radius.circular(5),
                // thumbVisibility: true,
                child: SingleChildScrollView(
                  // controller: _scrollController,
                  // contains ALL widgets (scrollable)
                  child: Column(
                    children: [
                      Column(
                        // first half widgets columns
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Input URL",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Enter a URL to shorten",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 80,
                                child: Tooltip(
                                  message: "Shorten URL in input field",
                                  child: Builder(
                                    builder: (context) => TextButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        wordToDefine = inputController.text;
                                        definition = await API
                                            .getiDefinition(wordToDefine);
                                        FocusScope.of(context).unfocus();
                                        // if (isURL(inputController.text)) {
                                        //   // check if device has internet connection
                                        //   var result =
                                        //       await Connectivity().checkConnectivity();
                                        //   if (result == ConnectivityResult.none) {
                                        //     // Show no internet connection error dialog
                                        //     Dialogs.showNoInternetConnection(context);
                                        //   } else {
                                        //     // device has network connectivity (android passes this even if only connected to hotel WiFi)
                                        //     wordToDefine = inputController.text;
                                        //     definition =
                                        //         await API.getiDefinition(wordToDefine);
                                        //     if (definition == null ||
                                        //         definition.idefinition == '') {
                                        //       Dialogs.showShorteningURLError(context);
                                        //     } else if (definition != null ||
                                        //         definition.idefinition != '') {
                                        //       HapticFeedback.lightImpact();
                                        //       final snackBar = SnackBar(
                                        //         behavior: SnackBarBehavior.floating,
                                        //         shape: RoundedRectangleBorder(
                                        //           borderRadius: BorderRadius.circular(
                                        //               25), // <-- Radius
                                        //         ),
                                        //         backgroundColor: Colors.orange[300],
                                        //         content: Row(
                                        //           children: <Widget>[
                                        //             Icon(
                                        //               Icons.check,
                                        //               color: Colors.black54,
                                        //             ),
                                        //             SizedBox(
                                        //               width: 10,
                                        //             ),
                                        //             AutoSizeText(
                                        //               'URL successfully shortened',
                                        //               textAlign: TextAlign.center,
                                        //               style: TextStyle(
                                        //                   fontSize: 16,
                                        //                   color: Colors.black54),
                                        //               maxLines: 1,
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       );
                                        //       ScaffoldMessenger.of(context)
                                        //           .hideCurrentSnackBar();
                                        //       ScaffoldMessenger.of(context)
                                        //           .showSnackBar(snackBar);
                                        //       outputController.text =
                                        //           definition.idefinition;
                                        //     }
                                        //   }
                                        // } else {
                                        //   Dialogs.showInvalidInput(context);
                                        //   outputController.text = '';
                                        // }
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue[700],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          AutoSizeText(
                                            "Shorten",
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          AutoSizeText(
                                            "URL",
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
