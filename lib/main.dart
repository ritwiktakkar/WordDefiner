import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dialogs.dart';
import 'package:WordDefiner/services/dictionaryAPI.dart' as FreeDictionaryAPI;
import 'package:WordDefiner/services/datamuseAPI.dart' as DatamuseAPI;

import 'package:flutter/services.dart';
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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    // to make volume loud on iOS: https://github.com/bluefireteam/audioplayers/issues/1194
    final AudioContext audioContext = AudioContext(
        iOS: AudioContextIOS(
          defaultToSpeaker: true,
          category: AVAudioSessionCategory.multiRoute,
          options: [
            AVAudioSessionOptions.defaultToSpeaker,
            // AVAudioSessionOptions.mixWithOthers,
          ],
        ),
        android: AudioContextAndroid(
          audioFocus: AndroidAudioFocus.gainTransient,
          usageType: AndroidUsageType.assistanceSonification,
          contentType: AndroidContentType.sonification,
          stayAwake: true,
          isSpeakerphoneOn: true,
        ));
    AudioPlayer.global.setGlobalAudioContext(audioContext);
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug banner from top left
      theme:
          // ThemeData(fontFamily: DefaultTextStyle.of(context).style.fontFamily),
          ThemeData.dark(),
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
  // Create a text controller and use it to retrieve the current value of the TextField.
  final inputController = TextEditingController();
  var inputFocusNode = FocusNode();
  final outputWordController = TextEditingController();
  final outputPhoneticController = TextEditingController();
  final pronounciationSourceController = TextEditingController();
  final meaningPartOfSpeechController = TextEditingController();
  final meaningDefinitionController = TextEditingController();
  final synonymController = TextEditingController();
  final antonymController = TextEditingController();
  final licenseNameController = TextEditingController();
  final licenseUrlsController = TextEditingController();
  final sourceUrlsController = TextEditingController();
  final stronglyAssociatedWordsController = TextEditingController();
  final similarlySpelledWordsController = TextEditingController();
  final similarSoundingWordsController = TextEditingController();
  final rhymingWordsController = TextEditingController();

  List<String> meaningPartOfSpeechList = <String>[];
  List<String> meaningDefinitionsList_tmp = <String>[];
  List<String> meaningSynonymsList = <String>[];
  List<String> meaningSynonymsList_tmp = <String>[];
  List<String> meaningAntonymsList = <String>[];
  List<String> meaningAntonymsList_tmp = <String>[];
  List<List<String>> meaningDefinitionsList = [];
  var meaningDefinitionsMap = new Map();
  List<String> meaningSynonymList = <String>[];
  var meaningSynonymMap = new Map();
  List<String> meaningAntonymList = <String>[];
  var meaningAntonymMap = new Map();
  List<String> licenseNames = <String>[];
  List<String> licenseUrls = <String>[];
  List<String> sourceUrls = <String>[];

  final audioPlayer = AudioPlayer();

  String wordToDefine = "";
  String? phonetic = '';
  String? pronounciationAudioSource = '';
  String? pronounciationSourceUrl = '';
  String wordExample = '';

  bool finding = false;

  int stronglyAssociatedWordsCount = 0;
  int similarSoundingWordsCount = 0;
  int similarSpeltWordsCount = 0;
  int rhymingWordsCount = 0;

  static const String appInfo =
      "Results powered by dictionaryapi.dev and the Datamuse API.\nWordDefiner English Dictionary (Version 3.1.0)\n© 2022-2023 Nocturnal Dev Lab (RT)";

  static const String appDisclaimer =
      "Using this app confirms that you agree with the privacy policy of WordDefiner, and exempt WordDefiner from any and all liability regarding the content(s) shown and functionality provided herein.";

  bool _stronglyAssociatedTileExpanded = false;
  bool _similarlySpeltTileExpanded = false;
  bool _similarSoundingTileExpanded = false;
  bool _rhymingTileExpanded = false;

  final validInputLetters = RegExp(r'^[a-zA-Z ]+$');

  void clearOutput(
      {bool alsoSearch = true,
      bool alsoWord = true,
      bool definitionsOnly = true,
      bool similarWords = true}) {
    if (alsoSearch == true) {
      inputController.clear();
    }
    if (alsoWord == true) {
      outputWordController.clear();
    }
    if (definitionsOnly == true) {
      outputPhoneticController.clear();
      pronounciationSourceController.clear();
      pronounciationAudioSource = '';
      pronounciationSourceUrl = '';
      audioPlayer.release();
      meaningPartOfSpeechController.clear();
      meaningDefinitionController.clear();
      synonymController.clear();
      antonymController.clear();
      licenseNameController.clear();
      licenseUrlsController.clear();
      sourceUrlsController.clear();
      meaningPartOfSpeechList.clear();
      meaningDefinitionsList_tmp.clear();

      meaningDefinitionsList.clear();
      meaningDefinitionsMap.clear();
      meaningSynonymList.clear();
      meaningAntonymList.clear();
      licenseNames.clear();
      licenseUrls.clear();
      sourceUrls.clear();
    }
    if (similarWords == true) {
      stronglyAssociatedWordsController.clear();
      similarlySpelledWordsController.clear();
      similarSoundingWordsController.clear();
      rhymingWordsController.clear();

      stronglyAssociatedWordsCount = 0;
      similarSoundingWordsCount = 0;
      similarSpeltWordsCount = 0;
      rhymingWordsCount = 0;
    }
  }

  void clearSearch() {
    HapticFeedback.lightImpact();
    inputController.clear();
    // shift focus back to input textfield
    FocusScope.of(context).requestFocus(inputFocusNode);
  }

  TextStyle sectionTitle = TextStyle(
    color: Colors.grey[400],
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  TextStyle word = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 26,
  );

  TextStyle body = TextStyle(
    color: Colors.grey[200],
    fontSize: 18,
  );

  TextStyle partOfSpeech = TextStyle(
    color: Colors.blue[100],
    fontSize: 18,
  );

  TextStyle synonyms = TextStyle(
    color: Colors.green[100],
    fontSize: 18,
  );

  TextStyle hint = TextStyle(
    color: Colors.grey[400],
    fontSize: 18,
  );

  TextStyle antonyms = TextStyle(
    color: Colors.red[100],
    fontSize: 18,
  );

  TextStyle subsectionTitle = TextStyle(
    color: Colors.grey[200],
    fontWeight: FontWeight.w300,
    fontSize: 18,
  );

  TextStyle corporate = TextStyle(
    color: Colors.grey,
    fontSize: 8,
  );

  @override
  void dispose() {
    // release memory allocated to existing variables of state
    inputController.dispose();
    outputWordController.dispose();
    outputPhoneticController.dispose();
    pronounciationSourceController.dispose();
    audioPlayer.release();
    meaningPartOfSpeechController.dispose();
    meaningDefinitionController.dispose();
    synonymController.dispose();
    antonymController.dispose();
    licenseNameController.dispose();
    licenseUrlsController.dispose();
    sourceUrlsController.dispose();
    stronglyAssociatedWordsController.dispose();
    similarlySpelledWordsController.dispose();
    similarSoundingWordsController.dispose();
    rhymingWordsController.dispose();
    meaningPartOfSpeechList.clear();
    meaningDefinitionsList_tmp.clear();

    meaningDefinitionsList.clear();
    meaningDefinitionsMap.clear();
    meaningSynonymList.clear();
    meaningSynonymMap.clear();
    meaningAntonymList.clear();
    meaningAntonymMap.clear();

    licenseNames.clear();
    licenseUrls.clear();
    sourceUrls.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black, // make background color black
        body: Container(
          padding: EdgeInsets.only(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            top: screenHeight * 0.06,
            bottom: 8,
          ),
          height: screenHeight * 0.96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: (finding &&
                        outputWordController.text.isEmpty &&
                        wordToDefine.isNotEmpty &&
                        (stronglyAssociatedWordsController.text.isEmpty &&
                            similarlySpelledWordsController.text.isEmpty &&
                            similarSoundingWordsController.text.isEmpty)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 60,
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: (wordToDefine.characters.length > 0)
                                  ? "Looking up: “${wordToDefine[0].toUpperCase()}${wordToDefine.substring(1).toLowerCase()}”"
                                  : "",
                              hintMaxLines: 3,
                              hintStyle: hint,
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (!finding &&
                        outputWordController.text.isEmpty &&
                        wordToDefine.isEmpty &&
                        (stronglyAssociatedWordsController.text.isEmpty &&
                            similarlySpelledWordsController.text.isEmpty &&
                            similarSoundingWordsController.text.isEmpty)),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 30,
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: "Results will appear here",
                                  hintStyle: hint,
                                  hintMaxLines: 2,
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                                hintText: appInfo,
                                hintMaxLines: 3,
                                hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300),
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (!finding &&
                        outputWordController.text.isEmpty &&
                        wordToDefine.isNotEmpty &&
                        (stronglyAssociatedWordsController.text.isNotEmpty ||
                            similarlySpelledWordsController.text.isNotEmpty ||
                            similarSoundingWordsController.text.isNotEmpty)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 80,
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: (wordToDefine.characters.length > 0)
                                  ? "No definitions found for “${wordToDefine[0].toUpperCase()}${wordToDefine.substring(1).toLowerCase()}” - but here are similar words"
                                  : "",
                              hintStyle: hint,
                              hintMaxLines: 5,
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (!finding &&
                        outputWordController.text.isEmpty &&
                        wordToDefine.isNotEmpty &&
                        stronglyAssociatedWordsController.text.isEmpty &&
                        similarlySpelledWordsController.text.isEmpty &&
                        similarSoundingWordsController.text.isEmpty),
                    child: Container(
                      height: 100,
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: (wordToDefine.characters.length > 0)
                                ? "No definitions or similar words found for “${wordToDefine[0].toUpperCase()}${wordToDefine.substring(1).toLowerCase()}”"
                                : "",
                            hintMaxLines: 5,
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ],
              ),
              // outputWord shown only if definition found on server
              Visibility(
                visible: outputWordController.text.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: screenWidth * .8,
                            child: SelectableText(
                              outputWordController.text,
                              style: word,
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            width: screenWidth * .1,
                            child: Column(
                              children: [
                                Visibility(
                                  visible: pronounciationAudioSource != '',
                                  child: Tooltip(
                                    message:
                                        'Press to hear the pronounciation of \"${outputWordController.text.toLowerCase()}\". If you can\'t hear anything, try restarting the app.',
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.hearing,
                                        color: Colors.yellow[200],
                                      ),
                                      iconSize: 24,
                                      onPressed: () {
                                        audioPlayer.setVolume(1);
                                        audioPlayer.play(UrlSource(
                                            pronounciationAudioSource!));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RawScrollbar(
                  thumbColor: Colors.grey,
                  thickness: 4,
                  radius: Radius.circular(5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: screenWidth * .3,
                              child: Visibility(
                                visible: meaningDefinitionsMap.isNotEmpty,
                                child: Text(
                                  "Definitions",
                                  style: sectionTitle,
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth * .6,
                              child: Visibility(
                                visible:
                                    outputPhoneticController.text.isNotEmpty,
                                child: SelectableText(
                                  outputPhoneticController.text,
                                  style: TextStyle(
                                    color: Colors.yellow[200],
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: meaningDefinitionsMap.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  itemCount: meaningDefinitionsMap.keys.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String key = meaningDefinitionsMap.keys
                                        .elementAt(index);
                                    String value = meaningDefinitionsMap.values
                                        .elementAt(index)
                                        .toString()
                                        .substring(
                                            1,
                                            meaningDefinitionsMap.values
                                                    .elementAt(index)
                                                    .toString()
                                                    .length -
                                                1)
                                        .replaceAll('.,', '\n—');
                                    List<String>? meaningSynonymList =
                                        meaningSynonymMap[meaningDefinitionsMap
                                            .keys
                                            .elementAt(index)] as List<String>;
                                    List<String>? meaningAntonymList =
                                        meaningAntonymMap[meaningDefinitionsMap
                                            .keys
                                            .elementAt(index)] as List<String>;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // part of speech
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            "${index + 1}. ${key[0].toUpperCase()}${key.substring(1).toLowerCase()}",
                                            style: partOfSpeech,
                                          ),
                                        ),
                                        // definitions for that part of speech
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "— ${value.toString()}",
                                            style: body,
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              meaningSynonymList.isNotEmpty,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Synonyms: ${meaningSynonymList.join(', ')}',
                                              style: synonyms,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              meaningAntonymList.isNotEmpty,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Antonyms: ${meaningAntonymList.join(', ')}',
                                              style: antonyms,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: ListBody(
                                  children: [
                                    Visibility(
                                      visible: pronounciationAudioSource != '',
                                      child: Text(
                                        'Audio: ${pronounciationSourceController.text}',
                                        style: corporate,
                                      ),
                                    ),
                                    SelectableText(
                                      "License name: ${licenseNameController.text}",
                                      style: corporate,
                                      maxLines: 1,
                                    ),
                                    SelectableText(
                                      "License URLs: ${licenseUrlsController.text}",
                                      style: corporate,
                                      maxLines: 1,
                                    ),
                                    SelectableText(
                                      "Source URLs: ${sourceUrlsController.text}",
                                      style: corporate,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: stronglyAssociatedWordsController
                                  .text.isNotEmpty ||
                              similarlySpelledWordsController.text.isNotEmpty ||
                              similarSoundingWordsController.text.isNotEmpty,
                          child: Divider(
                            color: Colors.grey[700],
                            thickness: 1,
                          ),
                        ),
                        Visibility(
                          visible:
                              stronglyAssociatedWordsController.text.isNotEmpty,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.all(0),
                            expandedAlignment: Alignment.topLeft,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (stronglyAssociatedWordsCount > 1)
                                      ? "${stronglyAssociatedWordsCount} strongly associated words "
                                      : "${stronglyAssociatedWordsCount} strongly associated word ",
                                  style: sectionTitle,
                                ),
                                Tooltip(
                                  message:
                                      "Words that may be commonly used with or related to \"${wordToDefine.toLowerCase()}\"",
                                  child: Icon(
                                    Icons.info_outline_rounded,
                                    size: 14,
                                    color: Colors.grey[300],
                                  ),
                                )
                              ],
                            ),
                            children: [
                              SelectableText(
                                stronglyAssociatedWordsController.text,
                                style: body,
                              ),
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _stronglyAssociatedTileExpanded = expanded;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible:
                              similarlySpelledWordsController.text.isNotEmpty,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.all(0),
                            expandedAlignment: Alignment.topLeft,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (similarSpeltWordsCount > 1)
                                      ? "${similarSpeltWordsCount} similarly spelt words "
                                      : "${similarSpeltWordsCount} similarly spelt word ",
                                  style: sectionTitle,
                                ),
                                Tooltip(
                                  message:
                                      "Words that are spelt similar to \"${wordToDefine.toLowerCase()}\"",
                                  child: Icon(
                                    Icons.info_outline_rounded,
                                    size: 14,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              SelectableText(
                                similarlySpelledWordsController.text,
                                style: body,
                              ),
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _similarlySpeltTileExpanded = expanded;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible:
                              similarSoundingWordsController.text.isNotEmpty,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.all(0),
                            expandedAlignment: Alignment.topLeft,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (similarSoundingWordsCount > 1)
                                      ? "${similarSoundingWordsCount} similar sounding words "
                                      : "${similarSoundingWordsCount} similar sounding word ",
                                  style: sectionTitle,
                                ),
                                Tooltip(
                                  message:
                                      "Words that sound similar to \"${wordToDefine.toLowerCase()}\"",
                                  child: Icon(
                                    Icons.info_outline_rounded,
                                    size: 14,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              SelectableText(
                                similarSoundingWordsController.text,
                                style: body,
                              ),
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _similarSoundingTileExpanded = expanded;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: rhymingWordsController.text.isNotEmpty,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.all(0),
                            expandedAlignment: Alignment.topLeft,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (rhymingWordsCount > 1)
                                      ? "${rhymingWordsCount} rhyming words "
                                      : "${rhymingWordsCount} rhyming word ",
                                  style: sectionTitle,
                                ),
                                Tooltip(
                                  message:
                                      "Words that rhyme with \"${wordToDefine.toLowerCase()}\"",
                                  child: Icon(
                                    Icons.info_outline_rounded,
                                    size: 14,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              SelectableText(
                                rhymingWordsController.text,
                                style: body,
                              ),
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _rhymingTileExpanded = expanded;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tooltip(
                    message: '$appDisclaimer\n$appInfo',
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.grey[700],
                      size: 16,
                    ),
                  ),
                  Tooltip(
                      message: "Clear all output fields",
                      child: IconButton(
                          iconSize: 26,
                          icon: Icon(
                            Icons.delete,
                            color: (meaningDefinitionsMap.isNotEmpty ||
                                    stronglyAssociatedWordsController
                                        .text.isNotEmpty ||
                                    similarlySpelledWordsController
                                        .text.isNotEmpty ||
                                    similarSoundingWordsController
                                        .text.isNotEmpty)
                                ? Colors.grey[200]
                                : Colors.grey[900],
                          ),
                          onPressed: () {
                            if (meaningDefinitionsMap.isNotEmpty ||
                                stronglyAssociatedWordsController
                                    .text.isNotEmpty ||
                                similarlySpelledWordsController
                                    .text.isNotEmpty ||
                                similarSoundingWordsController
                                    .text.isNotEmpty) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                clearOutput(
                                    alsoSearch: true,
                                    alsoWord: true,
                                    definitionsOnly: true,
                                    similarWords: true);
                                wordToDefine = '';
                              });
                              // shift focus back to input textfield
                              FocusScope.of(context)
                                  .requestFocus(inputFocusNode);
                            } else {
                              DoNothingAction();
                            }
                          })),
                  Container(
                    color: Colors.black87,
                    width: screenWidth * 0.72,
                    child: Container(
                      height: 50,
                      child: TextField(
                        focusNode: inputFocusNode,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                          ),
                          hintText: 'Look up a word',
                        ),
                        controller: inputController,
                        onSubmitted: ((_) async {
                          // wordToDefine = _.trim();
                          _ = _.trim();
                          if (_ == '') {
                            // CHECK 1: empty word - do nothing
                            finding = false;
                            // wordToDefine = '';
                            DoNothingAction();
                            inputController.clear();
                          } else if (!validInputLetters.hasMatch(_) ||
                              _.characters.contains(' ') ||
                              _.characters.length > 50) {
                            // CHECK 2: non letter, just space detected, or query exceeds 50 characters - show error dialog
                            Dialogs.showInputIssue(context);
                          } else {
                            // CHECK 1: check if device has internet connection
                            var result =
                                await Connectivity().checkConnectivity();
                            if (result == ConnectivityResult.none) {
                              // Show no internet connection error dialog
                              Dialogs.showNetworkIssues(context);
                            } else {
                              setState(() {
                                wordToDefine = _;
                                finding = true;
                                clearOutput(
                                    alsoSearch: true,
                                    alsoWord: true,
                                    definitionsOnly: true,
                                    similarWords: true);
                              });
                              try {
                                final definitionsList =
                                    (await FreeDictionaryAPI.getDefinition(
                                        wordToDefine));

                                final stronglyAssociatedWords =
                                    (await DatamuseAPI.getRelatedWords(
                                        wordToDefine));
                                stronglyAssociatedWordsCount =
                                    stronglyAssociatedWords!.length;
                                final similarSpelledWords =
                                    (await DatamuseAPI.getSimilarSpeltWords(
                                        wordToDefine));
                                similarSpeltWordsCount =
                                    similarSpelledWords!.length;
                                final similarSoundingWords =
                                    (await DatamuseAPI.getSimilarSoundingWords(
                                        wordToDefine));
                                similarSoundingWordsCount =
                                    similarSoundingWords!.length;
                                final rhymingWords =
                                    (await DatamuseAPI.getRhymingWords(
                                        wordToDefine));
                                rhymingWordsCount = rhymingWords!.length;
                                stronglyAssociatedWordsController.text =
                                    stronglyAssociatedWords
                                        .toString()
                                        .substring(
                                            1,
                                            stronglyAssociatedWords
                                                    .toString()
                                                    .length -
                                                1);
                                similarlySpelledWordsController.text =
                                    similarSpelledWords.toString().substring(
                                        1,
                                        similarSpelledWords.toString().length -
                                            1);
                                similarSoundingWordsController.text =
                                    similarSoundingWords.toString().substring(
                                        1,
                                        similarSoundingWords.toString().length -
                                            1);
                                rhymingWordsController.text = rhymingWords
                                    .toString()
                                    .substring(
                                        1, rhymingWords.toString().length - 1);
                                setState(() {
                                  finding = false;
                                  if (definitionsList!.isNotFound == true) {
                                    debugPrint('404 word not found');
                                    // Dialogs.showNoDefinitions(
                                    //     context, wordToDefine);
                                    // wordToDefine = '';
                                    clearOutput(
                                        alsoSearch: true,
                                        alsoWord: true,
                                        definitionsOnly: true,
                                        similarWords: false);
                                    // shift focus back to input textfield
                                    FocusScope.of(context)
                                        .requestFocus(inputFocusNode);
                                  } else if (definitionsList.isNull == true) {
                                    debugPrint('!caught exception!');
                                    wordToDefine = '';
                                    Dialogs.showNetworkIssues(context);
                                  } else {
                                    try {
                                      outputWordController.text =
                                          "${wordToDefine[0].toUpperCase()}${wordToDefine.substring(1).toLowerCase()}";
                                      // traverse through list of definitions and assign to controllers so user can see
                                      definitionsList.definitionElements
                                          ?.forEach((element) {
                                        // 1 - for phonetic (assign last phonetic to outputPhoneticController.text)
                                        debugPrint('enter 1');
                                        if (element.phonetic == null) {
                                          DoNothingAction();
                                        } else {
                                          phonetic = element.phonetic;
                                        }
                                        // assign phonetic to phonetic controller in 2.3 because that's last place to do it
                                        debugPrint('exit 1');
                                        // 2 - for pronounciation (look through each field in phonetics and assign last audio to pronounciationAudioSource)
                                        // 2.1 - for audio
                                        element.phonetics
                                            ?.forEach((elementPhonetic) {
                                          debugPrint('enter 2');
                                          if (elementPhonetic.audio == null ||
                                              elementPhonetic.audio == '') {
                                            DoNothingAction();
                                          } else {
                                            pronounciationAudioSource =
                                                elementPhonetic.audio as String;
                                          }
                                          // 2.2 - for audio source
                                          if (elementPhonetic.sourceUrl ==
                                                  null ||
                                              elementPhonetic.sourceUrl == '') {
                                            DoNothingAction();
                                          } else {
                                            pronounciationSourceUrl =
                                                elementPhonetic.sourceUrl
                                                    as String;
                                          }
                                          // 2.3 - find some phonetic if not already there since phonetics list also has some
                                          // debugPrint('1-${phonetic}');
                                          if (phonetic == '' &&
                                              elementPhonetic.text != null) {
                                            phonetic =
                                                elementPhonetic.text as String;
                                          }
                                          outputPhoneticController.text =
                                              phonetic!;
                                          // assign pronounciationSourceController.text to pronounciationSourceUrl
                                          pronounciationSourceController.text =
                                              pronounciationSourceUrl!;
                                          debugPrint('exit 2');
                                        });
                                        // 3 - for meanings (look through each field in meanings)
                                        element.meanings
                                            ?.forEach((elementMeaning) {
                                          debugPrint('enter 3');
                                          // each field in meanings has 1 partOfSpeech and 1 list of definitions which itself has a definition string, along with a list of synonyms and antonyms
                                          // 3.1 - add part of speech to list
                                          meaningPartOfSpeechList.add(
                                              elementMeaning.partOfSpeech
                                                  as String);
                                          // 3.2 - add definitions list to their list
                                          for (int i = 0;
                                              i <
                                                  meaningPartOfSpeechList
                                                      .length;
                                              i++) {
                                            elementMeaning.definitions?.forEach(
                                                (elementMeaningDefinitions) {
                                              meaningDefinitionsList_tmp.add(
                                                  elementMeaningDefinitions
                                                      .definition as String);
                                            });
                                            meaningDefinitionsMap[elementMeaning
                                                    .partOfSpeech] =
                                                meaningDefinitionsList_tmp;
                                            meaningDefinitionsList_tmp = [];

                                            elementMeaning.synonyms
                                                ?.forEach((element) {
                                              meaningSynonymsList_tmp
                                                  .add(element);
                                            });
                                            meaningSynonymMap[elementMeaning
                                                    .partOfSpeech] =
                                                meaningSynonymsList_tmp;
                                            meaningSynonymsList_tmp = [];

                                            elementMeaning.antonyms
                                                ?.forEach((element) {
                                              meaningAntonymsList_tmp
                                                  .add(element);
                                            });
                                            meaningAntonymMap[elementMeaning
                                                    .partOfSpeech] =
                                                meaningAntonymsList_tmp;
                                            meaningAntonymsList_tmp = [];
                                          }
                                        });
                                        debugPrint('exit 3');
                                        // 4 - for license
                                        debugPrint('enter 4');
                                        // 4.1 -  check if license name in licenseNames already
                                        (licenseNames
                                                .contains(element.license?.name)
                                            ? DoNothingAction()
                                            : (licenseNames.add(element
                                                .license?.name as String)));
                                        // 4.2 - check if license url in licenseUrls already
                                        (licenseUrls
                                                .contains(element.license?.url)
                                            ? DoNothingAction()
                                            : (licenseUrls.add(element
                                                .license?.url as String)));
                                        // assign license lists to their respective text editing controllers
                                        licenseNameController.text =
                                            licenseNames.join(', ');
                                        licenseUrlsController.text =
                                            licenseUrls.join(', ');
                                        debugPrint('exit 4');
                                        // 5 - for source urls (check if license name in licenseNames already)
                                        element.sourceUrls
                                            ?.forEach((elementSourceUrl) {
                                          debugPrint('enter 5');
                                          (sourceUrls.contains(elementSourceUrl)
                                              ? DoNothingAction()
                                              : (sourceUrls
                                                  .add(elementSourceUrl)));
                                        });
                                        // assign sourceUrls list to its text editing controller
                                        sourceUrlsController.text =
                                            sourceUrls.join(', ');
                                      });
                                      debugPrint('exit 5');
                                    } on Exception catch (e) {
                                      debugPrint('!caught exception! $e');
                                      setState(() {
                                        wordToDefine = '';
                                      });
                                      Dialogs.showNetworkIssues(context);
                                    }
                                  }
                                });
                              } on Exception catch (e) {
                                debugPrint('!caught exception! $e');
                                Dialogs.showNetworkIssues(context);
                              }
                            }
                          }
                        }),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
