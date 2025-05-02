import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dialogs.dart';
import 'package:WordDefiner/services/dictionaryAPI.dart' as FreeDictionaryAPI;
import 'package:WordDefiner/services/datamuseAPI.dart' as DatamuseAPI;
import 'package:WordDefiner/readBadWords.dart' as ReadBadWords;
import 'package:WordDefiner/readWords.dart' as ReadWords;
import 'package:WordDefiner/Analytics/constants.dart' as Constants;
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        // statusBarBrightness: Brightness.dark,
        statusBarColor: Color.fromARGB(255, 27, 27, 29),
        systemNavigationBarColor: Color.fromARGB(255, 27, 27, 29),
      ),
    );
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // to prevent rotation
    // to make volume loud on iOS: https://github.com/bluefireteam/audioplayers/issues/1194
    final AudioContext audioContext = AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {
            // AVAudioSessionOptions.defaultToSpeaker,
            AVAudioSessionOptions.mixWithOthers,
          },
        ),
        android: AudioContextAndroid(
          audioFocus: AndroidAudioFocus.gainTransient,
          usageType: AndroidUsageType.media,
          contentType: AndroidContentType.speech,
          stayAwake: true,
          isSpeakerphoneOn: true,
        ));
    // AudioPlayer.global.setGlobalAudioContext(audioContext);
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug banner from top left
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey, brightness: Brightness.dark),
      ),

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
  final followedByWordsController = TextEditingController();
  final precededByWordsController = TextEditingController();
  final nounsModifiedController = TextEditingController();
  final adjectivesModifiedController = TextEditingController();
  final synonymsController = TextEditingController();
  final antonymsController = TextEditingController();
  final hypernymsController = TextEditingController();
  final hyponymsController = TextEditingController();
  final holonymsController = TextEditingController();
  final meronymsController = TextEditingController();

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

  bool isBadWord = false;

  int stronglyAssociatedWordsCount = 0;
  int similarSoundingWordsCount = 0;
  int similarSpeltWordsCount = 0;
  int rhymingWordsCount = 0;
  int followedByWordsCount = 0;
  int precededByWordsCount = 0;
  int nounsModifiedCount = 0;
  int adjectivesModifiedCount = 0;
  int synonymsCount = 0;
  int antonymsCount = 0;
  int hypernymsCount = 0;
  int hyponymsCount = 0;
  int holonymsCount = 0;
  int meronymsCount = 0;

  String appVersion = '';
  String buildVersion = '';

  static const String appInfo = "Results by Datamuse API and Dictionary API.";

  static final String appDisclaimer =
      "The developer disclaims all liability for any direct, indirect, incidental, consequential, or special damages arising from or related to your use of the app, including but not limited to, any errors or omissions in the content provided, any interruptions or malfunctions of the app's functionality, or any reliance on information displayed within the app.";

  final validInputLetters = RegExp(r'^[a-zA-Z ]+$');

  void clearOutput(
      {bool alsoSearch = true,
      bool alsoWord = true,
      bool definitionsOnly = true,
      bool similarWords = true}) {
    isBadWord = false;
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
      followedByWordsController.clear();
      precededByWordsController.clear();
      nounsModifiedController.clear();
      adjectivesModifiedController.clear();
      synonymsController.clear();
      antonymsController.clear();
      hypernymsController.clear();
      hyponymsController.clear();
      holonymsController.clear();
      meronymsController.clear();

      stronglyAssociatedWordsCount = 0;
      similarSoundingWordsCount = 0;
      similarSpeltWordsCount = 0;
      rhymingWordsCount = 0;
      followedByWordsCount = 0;
      precededByWordsCount = 0;
      nounsModifiedCount = 0;
      adjectivesModifiedCount = 0;
      synonymsCount = 0;
      antonymsCount = 0;
      hypernymsCount = 0;
      hyponymsCount = 0;
      holonymsCount = 0;
      meronymsCount = 0;
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
    fontWeight: FontWeight.w500,
    fontSize: 17,
  );

  TextStyle word = TextStyle(
    color: Colors.grey[100],
    fontWeight: FontWeight.bold,
    fontSize: 28,
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
    fontWeight: FontWeight.w300,
    fontSize: 16,
  );

  TextStyle fail = TextStyle(
    color: Colors.red[300],
    fontWeight: FontWeight.w400,
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
    color: Colors.grey[800],
    fontSize: 10.5,
    fontWeight: FontWeight.w400,
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
    followedByWordsController.dispose();
    precededByWordsController.dispose();
    nounsModifiedController.dispose();
    adjectivesModifiedController.dispose();
    synonymsController.dispose();
    antonymsController.dispose();
    hypernymsController.dispose();
    hyponymsController.dispose();
    holonymsController.dispose();
    meronymsController.dispose();
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

    badWords.clear();

    super.dispose();
  }

  bool _definitionsTileExpanded = false;
  bool _stronglyAssociatedTileExpanded = false;
  bool _similarlySpeltTileExpanded = false;
  bool _similarSoundingTileExpanded = false;
  bool _rhymingTileExpanded = false;
  bool _followedByTileExpanded = false;
  bool _precededByTileExpanded = false;
  bool _nounsModifiedTileExpanded = false;
  bool _adjectivesModifiedTileExpanded = false;
  bool _synonymsTileExpanded = false;
  bool _antonymsTileExpanded = false;
  bool _hypernymsTileExpanded = false;
  bool _hyponymsTileExpanded = false;
  bool _holonymsTileExpanded = false;
  bool _meronymsTileExpanded = false;

  List<String> badWords = [];
  List<String> words = [];

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    ReadBadWords.readBadWordsFromFile().then((value) {
      setState(() {
        badWords = value;
      });
    });
    ReadWords.readWordsFromFile().then((value) {
      setState(() {
        words = value;
      });
    });
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
      buildVersion = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Container(
                height: screenHeight * .87,
                padding: const EdgeInsets.fromLTRB(20, 65, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Result status column
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          focusNode: inputFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            isDense: true,
                            fillColor: Colors.grey[900],
                            filled: true,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 24,
                            ),
                            contentPadding: EdgeInsets.all(10),
                            hintText: (finding) ? 'Searching...' : 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          controller: inputController,
                          onSubmitted: ((_) async {
                            _ = _.trim();
                            if (_ == '') {
                              // CHECK 1: empty word - do nothing
                              finding = false;
                              DoNothingAction();
                              inputController.clear();
                            } else if (!validInputLetters.hasMatch(_) ||
                                _.characters.contains(' ') ||
                                _.characters.length > 50) {
                              // CHECK 2: non letter, just space detected, or query exceeds 50 characters - show error dialog
                              Dialogs.showInputIssue(context);
                            } else if (!words.contains(_)) {
                              // CHECK 3: word not in list - show error dialog
                              Dialogs.showInvalidWord(context);
                            } else {
                              // CHECK 1: check if device has internet connection
                              var result =
                                  await Connectivity().checkConnectivity();
                              if (result == ConnectivityResult.none) {
                                debugPrint("no internet connection");
                                Future.delayed(Duration(seconds: 1), () {
                                  Dialogs.showNetworkIssues(context);
                                  setState(() {
                                    finding = false;
                                    inputController.clear();
                                    wordToDefine = '';
                                  });
                                });
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
                                  debugPrint("sent request to get definitions");
                                  final definitionsList =
                                      (await FreeDictionaryAPI.getDefinition(
                                          wordToDefine));
                                  debugPrint(
                                      "received request to get definitions");
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
                                      (await DatamuseAPI
                                          .getSimilarSoundingWords(
                                              wordToDefine));
                                  similarSoundingWordsCount =
                                      similarSoundingWords!.length;
                                  final rhymingWords =
                                      (await DatamuseAPI.getRhymingWords(
                                          wordToDefine));
                                  rhymingWordsCount = rhymingWords!.length;
                                  final followedByWords =
                                      (await DatamuseAPI.getFollowedByWords(
                                          wordToDefine));
                                  followedByWordsCount =
                                      followedByWords!.length;
                                  final precededByWords =
                                      (await DatamuseAPI.getPrecededByWords(
                                          wordToDefine));
                                  precededByWordsCount =
                                      precededByWords!.length;
                                  final nounsModified =
                                      (await DatamuseAPI.getNounsModified(
                                          wordToDefine));
                                  nounsModifiedCount = nounsModified!.length;
                                  final adjectivesModified =
                                      (await DatamuseAPI.getAdjectivesModified(
                                          wordToDefine));
                                  adjectivesModifiedCount =
                                      adjectivesModified!.length;
                                  final synonyms =
                                      (await DatamuseAPI.getSynonyms(
                                          wordToDefine));
                                  synonymsCount = synonyms!.length;
                                  final antonyms =
                                      (await DatamuseAPI.getAntonyms(
                                          wordToDefine));
                                  antonymsCount = antonyms!.length;
                                  final hypernyms =
                                      (await DatamuseAPI.getHypernyms(
                                          wordToDefine));
                                  hypernymsCount = hypernyms!.length;
                                  final hyponyms =
                                      (await DatamuseAPI.getHyponyms(
                                          wordToDefine));
                                  hyponymsCount = hyponyms!.length;
                                  final holonyms =
                                      (await DatamuseAPI.getHolonyms(
                                          wordToDefine));
                                  holonymsCount = holonyms!.length;
                                  final meronyms =
                                      (await DatamuseAPI.getMeronyms(
                                          wordToDefine));
                                  meronymsCount = meronyms!.length;

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
                                          similarSpelledWords
                                                  .toString()
                                                  .length -
                                              1);
                                  similarSoundingWordsController.text =
                                      similarSoundingWords.toString().substring(
                                          1,
                                          similarSoundingWords
                                                  .toString()
                                                  .length -
                                              1);
                                  rhymingWordsController.text = rhymingWords
                                      .toString()
                                      .substring(1,
                                          rhymingWords.toString().length - 1);
                                  followedByWordsController.text =
                                      followedByWords.toString().substring(
                                          1,
                                          followedByWords.toString().length -
                                              1);
                                  precededByWordsController.text =
                                      precededByWords.toString().substring(
                                          1,
                                          precededByWords.toString().length -
                                              1);
                                  nounsModifiedController.text = nounsModified
                                      .toString()
                                      .substring(1,
                                          nounsModified.toString().length - 1);
                                  adjectivesModifiedController.text =
                                      adjectivesModified.toString().substring(
                                          1,
                                          adjectivesModified.toString().length -
                                              1);
                                  synonymsController.text = synonyms
                                      .toString()
                                      .substring(
                                          1, synonyms.toString().length - 1);
                                  antonymsController.text = antonyms
                                      .toString()
                                      .substring(
                                          1, antonyms.toString().length - 1);
                                  hypernymsController.text = hypernyms
                                      .toString()
                                      .substring(
                                          1, hypernyms.toString().length - 1);
                                  hyponymsController.text = hyponyms
                                      .toString()
                                      .substring(
                                          1, hyponyms.toString().length - 1);
                                  holonymsController.text = holonyms
                                      .toString()
                                      .substring(
                                          1, holonyms.toString().length - 1);
                                  meronymsController.text = meronyms
                                      .toString()
                                      .substring(
                                          1, meronyms.toString().length - 1);
                                  setState(() {
                                    finding = false;
                                    debugPrint(
                                        "definitions list: ${definitionsList}");
                                    if (definitionsList?.isNotFound == true) {
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
                                    } else if (definitionsList?.isNull ==
                                        true) {
                                      debugPrint('definitions list is null');
                                      Future.delayed(Duration(seconds: 1), () {
                                        Dialogs.showNetworkIssues(context);
                                        setState(() {
                                          finding = false;
                                          inputController.clear();
                                          wordToDefine = '';
                                        });
                                      });
                                    } else {
                                      try {
                                        HapticFeedback.lightImpact();
                                        outputWordController.text =
                                            "${wordToDefine[0].toUpperCase()}${wordToDefine.substring(1).toLowerCase()}";
                                        if (badWords.contains(
                                            wordToDefine.toLowerCase())) {
                                          setState(() {
                                            isBadWord = true;
                                          });
                                        } else {
                                          setState(() {
                                            isBadWord = false;
                                          });
                                        }
                                        // traverse through list of definitions and assign to controllers so user can see
                                        definitionsList?.definitionElements
                                            ?.forEach((element) {
                                          // 1 - for phonetic (assign last phonetic to outputPhoneticController.text)
                                          debugPrint('enter 1');
                                          if (element.phonetic == null) {
                                            phonetic = '';
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
                                                  elementPhonetic.audio
                                                      as String;
                                            }
                                            // 2.2 - for audio source
                                            if (elementPhonetic.sourceUrl ==
                                                    null ||
                                                elementPhonetic.sourceUrl ==
                                                    '') {
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
                                              phonetic = elementPhonetic.text
                                                  as String;
                                            }
                                            outputPhoneticController.text =
                                                phonetic!;
                                            // assign pronounciationSourceController.text to pronounciationSourceUrl
                                            pronounciationSourceController
                                                    .text =
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
                                              meaningDefinitionsMap[
                                                      elementMeaning
                                                          .partOfSpeech] =
                                                  meaningDefinitionsList_tmp;
                                              meaningDefinitionsList_tmp = [];

                                              elementMeaning.synonymsEl
                                                  ?.forEach((element) {
                                                meaningSynonymsList_tmp
                                                    .add(element);
                                              });
                                              meaningSynonymMap[elementMeaning
                                                      .partOfSpeech] =
                                                  meaningSynonymsList_tmp;
                                              meaningSynonymsList_tmp = [];

                                              elementMeaning.antonymsEl
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
                                          (licenseNames.contains(
                                                  element.license?.name)
                                              ? DoNothingAction()
                                              : (licenseNames.add(element
                                                  .license?.name as String)));
                                          // 4.2 - check if license url in licenseUrls already
                                          (licenseUrls.contains(
                                                  element.license?.url)
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
                                            (sourceUrls
                                                    .contains(elementSourceUrl)
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
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          Dialogs.showNetworkIssues(context);
                                          setState(() {
                                            finding = false;
                                            inputController.clear();
                                            wordToDefine = '';
                                          });
                                        });
                                      }
                                    }
                                  });
                                } on Exception catch (e) {
                                  debugPrint('!caught exception! $e');
                                  Future.delayed(Duration(seconds: 1), () {
                                    Dialogs.showNetworkIssues(context);
                                    setState(() {
                                      finding = false;
                                      inputController.clear();
                                      wordToDefine = '';
                                    });
                                  });
                                }
                              }
                            }
                          }),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          readOnly: (finding) ? true : false,
                        ),
                        SizedBox(height: screenHeight * .015),
                        Visibility(
                          visible: (finding &&
                              outputWordController.text.isEmpty &&
                              wordToDefine.isNotEmpty &&
                              (stronglyAssociatedWordsController.text.isEmpty &&
                                  similarlySpelledWordsController
                                      .text.isEmpty &&
                                  similarSoundingWordsController.text.isEmpty)),
                          child: Text(
                            (wordToDefine.characters.length > 0)
                                ? "Looking up: “${wordToDefine}”"
                                : "",
                            style: word,
                          ),
                        ),
                        Visibility(
                          visible: (!finding &&
                              outputWordController.text.isEmpty &&
                              wordToDefine.isNotEmpty &&
                              (stronglyAssociatedWordsController
                                      .text.isNotEmpty ||
                                  similarlySpelledWordsController
                                      .text.isNotEmpty ||
                                  similarSoundingWordsController
                                      .text.isNotEmpty)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                                (wordToDefine.characters.length > 0)
                                    ? "No definition found for “${wordToDefine[0].toUpperCase()}${wordToDefine.substring(1).toLowerCase()}” — but here's what we did find:"
                                    : "",
                                style: fail),
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
                            child: Text(
                              (wordToDefine.characters.length > 0)
                                  ? "No definition or similar word found for “${wordToDefine[0].toUpperCase()}${wordToDefine.substring(1).toLowerCase()}” on dictionaryapi.dev 😔"
                                  : "",
                              style: fail,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //
                    Visibility(
                      visible: meaningDefinitionsMap.isNotEmpty,
                      child: Container(
                        height: (outputPhoneticController.text.isNotEmpty ||
                                pronounciationAudioSource != '')
                            ? 85
                            : 55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth * 0.88,
                              // color: Colors.amber,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: SelectableText(
                                    outputWordController.text,
                                    style: word,
                                    maxLines: 1,
                                  )),
                                  Visibility(
                                      visible: isBadWord,
                                      child: Tooltip(
                                        message:
                                            "Potentially offensive depending on context.",
                                        child: InkWell(
                                          child: Icon(
                                            Icons.warning_sharp,
                                            color: Colors.red[200],
                                            size: 24,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: screenWidth * .78,
                                  child: Visibility(
                                    visible: outputPhoneticController
                                        .text.isNotEmpty,
                                    child: SelectableText(
                                      outputPhoneticController.text,
                                      style: TextStyle(
                                        color: Colors.yellow[200],
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: screenWidth * .1,
                                  child: Visibility(
                                    visible: pronounciationAudioSource != '',
                                    child: Tooltip(
                                      message:
                                          'Tap to hear the pronounciation of \“${outputWordController.text.toLowerCase()}.\” If you can\'t hear anything, try restarting the app or checking the device volume.',
                                      child: InkWell(
                                        child: Icon(
                                          Icons.hearing,
                                          color: Colors.yellow[200],
                                          size: 24,
                                        ),
                                        onTap: () {
                                          audioPlayer.setVolume(1);
                                          audioPlayer.play(UrlSource(
                                              pronounciationAudioSource!));
                                        },
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
                              Visibility(
                                visible: meaningDefinitionsMap.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Text(
                                    (meaningDefinitionsMap.keys.length > 1)
                                        ? "Definitions for ${meaningDefinitionsMap.keys.length} parts of speech"
                                        : "Definition",
                                    style: sectionTitle,
                                  ),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.all(0),
                                            shrinkWrap: true,
                                            itemCount: meaningDefinitionsMap
                                                .keys.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              String key = meaningDefinitionsMap
                                                  .keys
                                                  .elementAt(index);
                                              String value =
                                                  meaningDefinitionsMap.values
                                                      .elementAt(index)
                                                      .toString()
                                                      .substring(
                                                          1,
                                                          meaningDefinitionsMap
                                                                  .values
                                                                  .elementAt(
                                                                      index)
                                                                  .toString()
                                                                  .length -
                                                              1)
                                                      .replaceAll(
                                                          '.,', '\n\u2022');
                                              List<String>? meaningSynonymList =
                                                  meaningSynonymMap[
                                                          meaningDefinitionsMap
                                                              .keys
                                                              .elementAt(index)]
                                                      as List<String>;
                                              List<String>? meaningAntonymList =
                                                  meaningAntonymMap[
                                                          meaningDefinitionsMap
                                                              .keys
                                                              .elementAt(index)]
                                                      as List<String>;
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // part of speech
                                                  Text(
                                                    "${index + 1}. Part of speech: ${key[0].toUpperCase()}${key.substring(1).toLowerCase()}",
                                                    style: partOfSpeech,
                                                  ),
                                                  // definitions for that part of speech
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      "\u2022 ${value.toString()}",
                                                      style: body,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: meaningSynonymList
                                                        .isNotEmpty,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        'Synonyms: ${meaningSynonymList.join(', ')}',
                                                        style: synonyms,
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: meaningAntonymList
                                                        .isNotEmpty,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
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
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                            bottom: 10,
                                          ),
                                          child: ListBody(
                                            children: [
                                              Visibility(
                                                visible:
                                                    pronounciationAudioSource !=
                                                        '',
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
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _definitionsTileExpanded = expanded;
                                    });
                                  },
                                  initiallyExpanded: true,
                                ),
                              ),
                              Visibility(
                                visible: synonymsController.text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        (synonymsCount > 1)
                                            ? "${synonymsCount} synonyms"
                                            : "${synonymsCount} synonym",
                                        style: sectionTitle,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: SelectableText(
                                            synonymsController.text,
                                            style: synonyms,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _synonymsTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: antonymsController.text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        (antonymsCount > 1)
                                            ? "${antonymsCount} antonyms"
                                            : "${antonymsCount} antonym",
                                        style: sectionTitle,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: SelectableText(
                                            antonymsController.text,
                                            style: antonyms,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _antonymsTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: stronglyAssociatedWordsController
                                    .text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        (stronglyAssociatedWordsCount > 1)
                                            ? "${stronglyAssociatedWordsCount} statistically associated words "
                                            : "${stronglyAssociatedWordsCount} statistically associated word ",
                                        style: sectionTitle,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        stronglyAssociatedWordsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _stronglyAssociatedTileExpanded =
                                          expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible:
                                    precededByWordsController.text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Often preceded by $precededByWordsCount ${precededByWordsCount > 1 ? "words" : "word"}",
                                        style: sectionTitle,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        precededByWordsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _precededByTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible:
                                    followedByWordsController.text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Often followed by $followedByWordsCount ${followedByWordsCount > 1 ? "words" : "word"}",
                                        style: sectionTitle,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        followedByWordsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _followedByTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: hypernymsController.text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        (hypernymsCount > 1)
                                            ? "${hypernymsCount} hypernyms "
                                            : "${hypernymsCount} hypernym ",
                                        style: sectionTitle,
                                      ),
                                      Tooltip(
                                        message:
                                            'Hypernyms are words that are more general than the word being defined.',
                                        child: Icon(
                                          Icons.lightbulb_outlined,
                                          color: Colors.grey[800],
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        hypernymsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _hypernymsTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: hyponymsController.text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        (hyponymsCount > 1)
                                            ? "${hyponymsCount} hyponyms "
                                            : "${hyponymsCount} hyponym ",
                                        style: sectionTitle,
                                      ),
                                      Tooltip(
                                        message:
                                            'Hyponyms are words that are more specific than the word being defined.',
                                        child: Icon(
                                          Icons.lightbulb_outlined,
                                          color: Colors.grey[800],
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        hyponymsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _hyponymsTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: holonymsController.text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Holonym ",
                                        style: sectionTitle,
                                      ),
                                      Tooltip(
                                        message:
                                            'Holonyms are words that define the whole, whereas meronyms define the parts.',
                                        child: Icon(
                                          Icons.lightbulb_outlined,
                                          color: Colors.grey[800],
                                          size: 16,
                                        ),
                                      ),
                                      Text(
                                          " for ${holonymsCount} ${holonymsCount > 1 ? "words" : "word"}",
                                          style: sectionTitle)
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        holonymsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _holonymsTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: meronymsController.text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Meronym ",
                                        style: sectionTitle,
                                      ),
                                      Tooltip(
                                        message:
                                            'Meronyms are words that define the parts, whereas holonyms define the whole.',
                                        child: Icon(
                                          Icons.lightbulb_outlined,
                                          color: Colors.grey[800],
                                          size: 16,
                                        ),
                                      ),
                                      Text(
                                        " for $meronymsCount ${meronymsCount > 1 ? "words" : "word"}",
                                        style: sectionTitle,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        meronymsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _meronymsTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible:
                                    nounsModifiedController.text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Often describes $nounsModifiedCount ${nounsModifiedCount > 1 ? "nouns" : "noun"}",
                                        style: sectionTitle,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        nounsModifiedController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _nounsModifiedTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: adjectivesModifiedController
                                    .text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Often described by $adjectivesModifiedCount ${adjectivesModifiedCount > 1 ? "adjectives" : "adjective"}",
                                        style: sectionTitle,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        adjectivesModifiedController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _adjectivesModifiedTileExpanded =
                                          expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: similarlySpelledWordsController
                                    .text.isNotEmpty,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        (similarSpeltWordsCount > 1)
                                            ? "${similarSpeltWordsCount} similarly spelled words "
                                            : "${similarSpeltWordsCount} similarly spelled word ",
                                        style: sectionTitle,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        similarlySpelledWordsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _similarlySpeltTileExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: similarSoundingWordsController
                                    .text.isNotEmpty,
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
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        similarSoundingWordsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
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
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SelectableText(
                                        rhymingWordsController.text,
                                        style: body,
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    HapticFeedback.lightImpact();
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
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tooltip(
                    message: '$appDisclaimer',
                    child: Icon(
                      Icons.policy_outlined,
                      color: Colors.grey[800],
                      size: 18,
                    ),
                  ),
                  Text(
                    appInfo,
                    style: corporate,
                  ),
                  Tooltip(
                    message: "Clear all output fields.",
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
                              : Colors.grey[800],
                        ),
                        onPressed: () {
                          if (meaningDefinitionsMap.isNotEmpty ||
                              stronglyAssociatedWordsController
                                  .text.isNotEmpty ||
                              similarlySpelledWordsController.text.isNotEmpty ||
                              similarSoundingWordsController.text.isNotEmpty) {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              clearOutput(
                                  alsoSearch: true,
                                  alsoWord: true,
                                  definitionsOnly: true,
                                  similarWords: true);
                              wordToDefine = '';
                            });
                            // shift focus back to input textfield
                            FocusScope.of(context).requestFocus(inputFocusNode);
                          } else {
                            DoNothingAction();
                          }
                        }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "WordDefiner v$appVersion",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Build $buildVersion",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 9,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "\u00A9 2022–${DateTime.now().year.toString()} RT",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 9,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Tooltip(
                    message: "Link to feedback form.",
                    child: IconButton(
                      onPressed: () {
                        Dialogs.showContactDialog(context);
                        debugPrint(
                            "COLOR: ${Theme.of(context).colorScheme.surface.toString()}");
                      },
                      icon: Icon(
                        Icons.contact_page_outlined,
                        color: Colors.grey[400],
                        size: 23,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: Platform.isIOS || Platform.isMacOS,
                    child: Tooltip(
                      message:
                          "Open Popops — a fun game that combines mesmerizing visuals with lightning-fast gameplay for a unique experience anyone can pick up, but few can master.",
                      child: IconButton(
                        onPressed: () async {
                          await LaunchApp.openApp(
                            iosUrlScheme: Constants.popopsURLScheme,
                            appStoreLink: Constants.popopsURL,
                          );
                        },
                        icon: Image.asset(
                          "assets/popops_gs.png",
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: Platform.isIOS || Platform.isMacOS,
                    child: Tooltip(
                      message:
                          "Open WWYD — a community-driven app for iOS where users respond to daily hypothetical and real-world scenarios, then see how their choices compare to others.",
                      child: IconButton(
                        onPressed: () async {
                          await LaunchApp.openApp(
                            iosUrlScheme: Constants.wwydURLScheme,
                            appStoreLink: Constants.wwydURL,
                          );
                        },
                        icon: Image.asset(
                          "assets/wwyd_gs.png",
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message:
                        "Open ShortenMyURL to shorten links quickly, simply, and for free.",
                    child: IconButton(
                      onPressed: () async {
                        await LaunchApp.openApp(
                          androidPackageName:
                              Constants.shortenmyurlAndroidPackageName,
                          iosUrlScheme: Constants.shortenmyurlURLScheme,
                          appStoreLink: Constants.shortenmyurlURL,
                        );
                      },
                      icon: Image.asset(
                        "assets/shortenmyurl_gs.png",
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: "Share this app.",
                    child: IconButton(
                        iconSize: 20,
                        icon: Icon(
                          Icons.ios_share,
                          color: Colors.grey[300],
                        ),
                        onPressed: () async {
                          await Share.share(
                              "Try the lightweight, powerful, and free English dictionary, thesaurus, and rhyming words app, WordDefiner: " +
                                  (Platform.isAndroid
                                      ? Constants.worddefinerURLAndroid
                                      : Constants.worddefinerURLApple));
                        }),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
