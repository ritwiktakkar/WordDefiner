import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dialogs.dart';
import 'package:iDefine/services/get_definition.dart' as API;
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final outputPhoneticController = TextEditingController();

  final audioPlayer = AudioPlayer();

  String wordToDefine = "";
  String pronounciationAudioSource = '';

  TextStyle sectionTitle = TextStyle(
    color: CupertinoColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );

  TextStyle word = TextStyle(
    color: CupertinoColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 35,
  );

  TextStyle phonetic = TextStyle(
    color: CupertinoColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );

  TextStyle subsectionTitle = TextStyle(
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
                        if (definitionsList.isNotFound == true) {
                          debugPrint('404 word not found');
                          outputPhoneticController.clear();
                          pronounciationAudioSource = '';
                          audioPlayer.release();
                          Dialogs.showNoDefinitions(context);
                        } else if (definitionsList.isNull == true) {
                          debugPrint('!caught exception!');
                          outputPhoneticController.clear();
                          audioPlayer.release();
                          pronounciationAudioSource = '';
                          Dialogs.showNetworkIssues(context);
                        } else {
                          // traverse through list of definitions
                          // outputPhoneticController.text = definitionsList
                          //     .definitionElements?[0].phonetic as String;
                          definitionsList.definitionElements
                              ?.forEach((element) {
                            // 1 - for phonetic (assign last phonetic to outputPhoneticController.text)
                            ((element.phonetic != '')
                                ? (outputPhoneticController.text =
                                    element.phonetic as String)
                                : (outputPhoneticController.text = ''));
                            // 2 - for pronounciation (look through each field in phonetics and assign last audio to pronounciationAudioSource)
                            element.phonetics?.forEach((elementPhonetic) {
                              ((elementPhonetic.audio != '')
                                  ? (pronounciationAudioSource =
                                      elementPhonetic.audio as String)
                                  : (pronounciationAudioSource = ''));
                            });
                          });
                          // pronounciationAudioSource = definitionsList
                          //     .definitionElements?[0]
                          //     .phonetics?[1]
                          //     .audio as String;
                          // debugPrint(pronounciationAudioSource);
                        }
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
                                            style: sectionTitle,
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
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: screenWidth * .3,
                                          child: AutoSizeText(
                                            "Phonetic",
                                            style: sectionTitle,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: screenWidth * 0.03,
                                          ),
                                          width: screenWidth * .7,
                                          child: AutoSizeText(
                                            outputPhoneticController.text,
                                            style: phonetic,
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
                                      // mainAxisAlignment:
                                      // MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: screenWidth * .6,
                                          child: AutoSizeText(
                                            "Pronounciation",
                                            style: sectionTitle,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              (pronounciationAudioSource != ''),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: screenWidth * 0.03,
                                            ),
                                            width: screenWidth * .4,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    CupertinoIcons
                                                        .speaker_2_fill,
                                                    color: CupertinoColors
                                                        .activeBlue,
                                                  ),
                                                  onPressed: () {
                                                    audioPlayer.play(UrlSource(
                                                        pronounciationAudioSource));
                                                    // audioPlayer.resume();
                                                    // audioPlayer.play;
                                                  },
                                                ),
                                              ],
                                            ),
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
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: screenWidth * .3,
                                          child: AutoSizeText(
                                            "Meanings",
                                            style: sectionTitle,
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
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceAround,
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
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceAround,
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
                                                  outputWordController.clear();
                                                  outputPhoneticController
                                                      .clear();
                                                  pronounciationAudioSource =
                                                      '';
                                                  audioPlayer.release();
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
