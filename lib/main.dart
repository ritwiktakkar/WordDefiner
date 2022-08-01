import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dialogs.dart';
import 'package:iDefine/api_requests.dart' as API;
import 'package:flutter/services.dart';
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
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future<definition.Definition> definition;

  // Create a text controller and use it to retrieve the current value of the TextField.
  final inputController = TextEditingController();
  final outputWordController = TextEditingController();

  String wordToDefine = "";

  TextStyle title = TextStyle(
    color: CupertinoColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );

  TextStyle word = TextStyle(
    color: CupertinoColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 35,
  );

  TextStyle subtitle = TextStyle(
    color: CupertinoColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  TextStyle corporate = TextStyle(
    color: CupertinoColors.systemGrey,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputController.dispose();
    outputWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black, // make background color black
        body: Column(
          children: [
            Container(
              height: screenHeight * 0.95,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.05,
                      bottom: 20,
                    ),
                    child: CupertinoSearchTextField(
                      placeholder: 'Look up a word',
                      controller: inputController,
                      onSubmitted: ((String wordToDefine) async {
                        outputWordController.text = wordToDefine;
                        final definitionsList =
                            (await API.getDefinition(wordToDefine));
                        debugPrint(
                            '${definitionsList.toString()}\n${definitionsList.length}');
                        // debugPrint(
                        //     '${definition}, ${definition.toString()}, ${definition.word}, ${definition.phonetic}');
                        // if (definition.word == '-') {
                        //   debugPrint('404 word not found');
                        //   Dialogs.showNoDefinitions(context);
                        // } else if (definition.word == '') {
                        //   debugPrint('!caught exception!');
                        //   Dialogs.showNetworkIssues(context);
                        // }
                      }),
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
                                Column(
                                  children: [
                                    Row(
                                      // mainAxisAlignment:
                                      // MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: screenWidth * .3,
                                          child: AutoSizeText(
                                            "Word",
                                            style: title,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth * .7,
                                          child: AutoSizeText(
                                            outputWordController.text,
                                            style: word,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      // divider between first and second half of widgets
                                      color: Colors.grey[800],
                                      thickness: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: screenWidth * .3,
                                          child: AutoSizeText(
                                            "Phonetic",
                                            style: title,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: screenWidth * 0.03,
                                          ),
                                          width: screenWidth * .7,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      // divider between first and second half of widgets
                                      color: Colors.grey[800],
                                      thickness: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: screenWidth * .3,
                                          child: AutoSizeText(
                                            "Phonetics",
                                            style: title,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: screenWidth * 0.03,
                                          ),
                                          width: screenWidth * .7,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      // divider between first and second half of widgets
                                      color: Colors.grey[800],
                                      thickness: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: screenWidth * .3,
                                          child: AutoSizeText(
                                            "Meanings",
                                            style: title,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: screenWidth * 0.03,
                                          ),
                                          width: screenWidth * .7,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      // divider between first and second half of widgets
                                      color: Colors.grey[800],
                                      thickness: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: screenWidth * .3,
                                          child: Text(
                                            "License",
                                            style: corporate,
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth * .7,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: screenWidth * .3,
                                          child: Text(
                                            "Source URLs",
                                            style: corporate,
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth * .7,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Visibility(
                                          visible:
                                              outputWordController.text != '',
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 8,
                                              // right: screenWidth * 0.8,
                                            ),
                                            // width: screenWidth * 0.2,
                                            // height: screenHeight * 0.08,
                                            child: Tooltip(
                                              message:
                                                  "Clear all output fields",
                                              child: TextButton(
                                                onPressed: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  HapticFeedback.mediumImpact();
                                                  outputWordController.text =
                                                      '';
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.red[200],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    AutoSizeText(
                                                      "Clear",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                  ],
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
            Text(
              "Definitions from Dictionary API: dictionaryapi.dev/",
              style: corporate,
            )
          ],
        ),
      ),
    );
  }
}
