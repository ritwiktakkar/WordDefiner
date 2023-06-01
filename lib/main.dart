import 'package:flutter/material.dart';
import 'dialogs.dart';
import 'package:WordDefiner/services/get_definition.dart' as API;
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
  // final meaningSynonymsController = TextEditingController();
  // final meaningAntonymsController = TextEditingController();
  // final meaningExampleController = TextEditingController();
  final licenseNameController = TextEditingController();
  final licenseUrlsController = TextEditingController();
  final sourceUrlsController = TextEditingController();

  List<String> meaningPartOfSpeechList = <String>[];
  List<String> meaningDefinitionsList_1 = <String>[];
  List<String> meaningDefinitionsList_tmp = <String>[];
  List<List<String>> meaningDefinitionsList = [];
  var meaningDefinitionsMap = new Map();
  List<String> meaningSynonymList = <String>[];
  List<String> meaningAntonymList = <String>[];
  List<String> meaningExampleList = <String>[];
  List<String> licenseNames = <String>[];
  List<String> licenseUrls = <String>[];
  List<String> sourceUrls = <String>[];

  final audioPlayer = AudioPlayer();

  String wordToDefine = "";
  String? phonetic = '';
  String? pronounciationAudioSource = '';
  String? pronounciationSourceUrl = '';
  String wordExample = '';

  final validInputLetters = RegExp(r'^[a-zA-Z ]+$');

  void clearAllOutput({bool alsoSearch = false, bool alsoWord = false}) {
    // FocusScope.of(context).unfocus();
    if (alsoSearch == true) {
      inputController.clear();
    }
    if (alsoWord == true) {
      outputWordController.clear();
    }
    phonetic = '';
    outputPhoneticController.clear();
    pronounciationSourceController.clear();
    pronounciationAudioSource = '';
    pronounciationSourceUrl = '';
    audioPlayer.release();
    meaningPartOfSpeechController.clear();
    meaningDefinitionController.clear();
    // meaningSynonymsController.clear();
    // meaningAntonymsController.clear();
    // meaningExampleController.clear();
    licenseNameController.clear();
    licenseUrlsController.clear();
    sourceUrlsController.clear();
    meaningPartOfSpeechList.clear();
    meaningDefinitionsList_1.clear();
    meaningDefinitionsList_tmp.clear();
    meaningDefinitionsList.clear();
    meaningDefinitionsMap.clear();
    meaningSynonymList.clear();
    meaningAntonymList.clear();
    meaningExampleList.clear();
    licenseNames.clear();
    licenseUrls.clear();
    sourceUrls.clear();
  }

  void clearSearch() {
    HapticFeedback.lightImpact();
    inputController.clear();
    // shift focus back to input textfield
    FocusScope.of(context).requestFocus(inputFocusNode);
  }

  TextStyle sectionTitle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );

  TextStyle word = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  TextStyle body = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  TextStyle bodyItalic = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 18,
  );

  TextStyle synonymsAntonyms = TextStyle(
    color: Colors.grey[300],
    fontWeight: FontWeight.w300,
    fontSize: 17,
  );

  TextStyle subsectionTitle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  TextStyle corporate = TextStyle(
    color: Colors.grey,
    fontSize: 10,
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
    // meaningSynonymsController.dispose();
    // meaningAntonymsController.dispose();
    // meaningExampleController.dispose();
    licenseNameController.dispose();
    licenseUrlsController.dispose();
    sourceUrlsController.dispose();
    meaningPartOfSpeechList.clear();
    meaningDefinitionsList_1.clear();
    meaningDefinitionsList_tmp.clear();
    meaningDefinitionsList.clear();
    meaningDefinitionsMap.clear();
    meaningSynonymList.clear();
    meaningAntonymList.clear();
    meaningExampleList.clear();
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black, // make background color black
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
              ),
              height: screenHeight * 0.98,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.06,
                      bottom: 20,
                    ),
                    child: TextField(
                      focusNode: inputFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: inputController.text != ''
                            ? IconButton(
                                icon: Icon(Icons.clear), onPressed: clearSearch)
                            : null,
                        border: OutlineInputBorder(),
                        hintText: 'Look up a word',
                      ),
                      // placeholder: 'Look up a word',
                      controller: inputController,
                      onSubmitted: ((String wordToDefine) async {
                        clearAllOutput();
                        if (wordToDefine == '') {
                          // empty word - do nothing
                          DoNothingAction();
                        } else if (!validInputLetters.hasMatch(wordToDefine)) {
                          // non letter detected
                          Dialogs.showInputIssue(context);
                          setState(() {
                            // inputController.text = '';
                            clearAllOutput(alsoSearch: true, alsoWord: true);
                            debugPrint(
                                'clear input word controller and clearAll');
                          });
                        } else {
                          final definitionsList =
                              (await API.getDefinition(wordToDefine));
                          setState(() {
                            if (definitionsList.isNotFound == true) {
                              debugPrint('404 word not found');
                              Dialogs.showNoDefinitions(context, wordToDefine);
                              clearAllOutput(alsoSearch: true, alsoWord: true);
                              // shift focus back to input textfield
                              FocusScope.of(context)
                                  .requestFocus(inputFocusNode);
                            } else if (definitionsList.isNull == true) {
                              debugPrint('!caught exception!');
                              Dialogs.showNetworkIssues(context);
                            } else {
                              outputWordController.text =
                                  wordToDefine.toLowerCase();
                              // traverse through list of definitions and assign to controllers so user can see
                              definitionsList.definitionElements
                                  ?.forEach((element) {
                                // 1 - for phonetic (assign last phonetic to outputPhoneticController.text)
                                debugPrint('enter 1');
                                // below don't work if there is no phonetic field
                                // (((element.phonetic != '') ||
                                //         (element.phonetic != null))
                                //     ? (phonetic = element.phonetic as String)
                                //     : DoNothingAction());
                                if (element.phonetic == null) {
                                  DoNothingAction(); // try to get in 2.3
                                } else {
                                  phonetic = element.phonetic;
                                }
                                // debugPrint('phonetic: ${phonetic}');
                                // assign phonetic to phonetic controller in 2.3 because that's last place to do it
                                debugPrint('exit 1');
                                // 2 - for pronounciation (look through each field in phonetics and assign last audio to pronounciationAudioSource)
                                // 2.1 - for audio
                                element.phonetics?.forEach((elementPhonetic) {
                                  debugPrint('enter 2');
                                  if (elementPhonetic.audio == null ||
                                      elementPhonetic.audio == '') {
                                    DoNothingAction();
                                  } else {
                                    pronounciationAudioSource =
                                        elementPhonetic.audio as String;
                                  }
                                  // (((elementPhonetic.audio != '') ||
                                  //         (elementPhonetic.audio != null))
                                  //     ? (pronounciationAudioSource =
                                  //         elementPhonetic.audio as String)
                                  //     : DoNothingAction());
                                  // 2.2 - for audio source
                                  if (elementPhonetic.sourceUrl == null ||
                                      elementPhonetic.sourceUrl == '') {
                                    DoNothingAction();
                                  } else {
                                    pronounciationSourceUrl =
                                        elementPhonetic.sourceUrl as String;
                                  }
                                  // (((elementPhonetic.sourceUrl != '') ||
                                  //         (elementPhonetic.sourceUrl != null))
                                  //     ? (pronounciationSourceUrl =
                                  //         elementPhonetic.sourceUrl as String)
                                  //     : DoNothingAction());
                                  // 2.3 - find some phonetic if not already there since phonetics list also has some
                                  // debugPrint('1-${phonetic}');
                                  if (phonetic == '' &&
                                      elementPhonetic.text != null) {
                                    phonetic = elementPhonetic.text as String;
                                  }
                                  // debugPrint('2-${phonetic}');
                                  outputPhoneticController.text = phonetic!;
                                  // assign pronounciationSourceController.text to pronounciationSourceUrl
                                  pronounciationSourceController.text =
                                      pronounciationSourceUrl!;
                                  debugPrint('exit 2');
                                });
                                // 3 - for meanings (look through each field in meanings)
                                element.meanings?.forEach((elementMeaning) {
                                  debugPrint('enter 3');
                                  // 3.1 - add part of speech to list
                                  meaningPartOfSpeechList.add(
                                      elementMeaning.partOfSpeech as String);
                                  // 3.2 - add definitions list to their list
                                  for (int i = 0;
                                      i < meaningPartOfSpeechList.length;
                                      i++) {
                                    elementMeaning.definitions
                                        ?.forEach((elementMeaningDefinitions) {
                                      meaningDefinitionsList_1.add(
                                          elementMeaningDefinitions.definition
                                              as String);
                                    });
                                    meaningDefinitionsMap[
                                            elementMeaning.partOfSpeech] =
                                        meaningDefinitionsList_1;
                                    meaningDefinitionsList_1 = [];
                                  }
                                });
                                debugPrint('exit 3');
                                // 4 - for license
                                debugPrint('enter 4');
                                // 4.1 -  check if license name in licenseNames already
                                (licenseNames.contains(element.license?.name)
                                    ? DoNothingAction()
                                    : (licenseNames
                                        .add(element.license?.name as String)));
                                // 4.2 - check if license url in licenseUrls already
                                (licenseUrls.contains(element.license?.url)
                                    ? DoNothingAction()
                                    : (licenseUrls
                                        .add(element.license?.url as String)));
                                // assign license lists to their respective text editing controllers
                                licenseNameController.text =
                                    licenseNames.join(', ');
                                licenseUrlsController.text =
                                    licenseUrls.join(', ');
                                debugPrint('exit 4');
                                // 5 - for source urls (check if license name in licenseNames already)
                                element.sourceUrls?.forEach((elementSourceUrl) {
                                  debugPrint('enter 5');
                                  (sourceUrls.contains(elementSourceUrl)
                                      ? DoNothingAction()
                                      : (sourceUrls.add(elementSourceUrl)));
                                });
                                // assign sourceUrls list to its text editing controller
                                sourceUrlsController.text =
                                    sourceUrls.join(', ');
                              });
                              debugPrint('exit 5');
                            }
                          });
                        }
                      }),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      // itemColor: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: RawScrollbar(
                      thumbColor: Colors.grey,
                      thickness: 4,
                      radius: Radius.circular(5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: screenWidth * 0.3,
                                  child: AutoSizeText(
                                    (outputWordController.text != '')
                                        ? "Word:"
                                        : "Word",
                                    style: sectionTitle,
                                    maxLines: 1,
                                  ),
                                ),
                                Container(
                                  width: screenWidth * 0.62,
                                  padding: EdgeInsets.only(
                                    left: 12,
                                    // bottom: 8,
                                  ),
                                  child: Scrollbar(
                                    // crossAxisMargin:
                                    //     (MediaQuery.of(context).orientation ==
                                    //             Orientation.landscape)
                                    //         ? -(screenHeight) * 0.02
                                    //         : -(screenHeight) * 0.01,
                                    // mainAxisMargin: 100,
                                    // isAlwaysShown: true,
                                    child: SelectableText(
                                      (outputWordController.text != '')
                                          ? outputWordController.text
                                          : '',
                                      style: word,
                                      maxLines: 1,
                                    ),
                                  ),
                                  // alignment: Alignment.center,
                                ),
                              ],
                            ),
                            Divider(
                              // divider between first and second half of widgets
                              color: Colors.grey[800],
                              thickness: 2,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: screenWidth * .3,
                                  child: AutoSizeText(
                                    (phonetic != null && phonetic != '')
                                        ? "Phonetic:"
                                        : "Phonetic",
                                    style: sectionTitle,
                                    maxLines: 1,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 12,
                                  ),
                                  width: screenWidth * 0.62,
                                  // alignment: Alignment.center,
                                  child: SelectableText(
                                    outputPhoneticController.text,
                                    style: subsectionTitle,
                                    // textAlign: TextAlign.center,
                                    maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
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
                              children: [
                                Container(
                                  width: screenWidth * .3,
                                  child: AutoSizeText(
                                    (pronounciationAudioSource != '')
                                        ? "Listen:"
                                        : "Listen",
                                    style: sectionTitle,
                                    maxLines: 1,
                                  ),
                                ),
                                Visibility(
                                  visible: (pronounciationAudioSource != ''),
                                  child: Container(
                                    width: screenWidth * .62,
                                    child: Row(
                                      children: [
                                        Tooltip(
                                          message:
                                              'Press to hear the pronounciation of \"${outputWordController.text.toLowerCase()}\". If you can\'t hear anything, try restarting the app.',
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.hearing,
                                              color: Colors.blue,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              audioPlayer.setVolume(1);
                                              audioPlayer.play(UrlSource(
                                                  pronounciationAudioSource!));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible:
                                  pronounciationSourceController.text != '',
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: SelectableText(
                                    '${pronounciationSourceController.text}',
                                    style: corporate,
                                    maxLines: 1,
                                  )),
                            ),
                            Divider(
                              // divider between first and second half of widgets
                              color: Colors.grey[800],
                              thickness: 2,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      (meaningDefinitionsMap.isNotEmpty)
                                          ? "Meanings:"
                                          : "Meanings",
                                      style: sectionTitle,
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: meaningDefinitionsMap.isNotEmpty,
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.all(0),
                                          shrinkWrap: true,
                                          itemCount:
                                              meaningDefinitionsMap.keys.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String key = meaningDefinitionsMap
                                                .keys
                                                .elementAt(index);
                                            String value = meaningDefinitionsMap
                                                .values
                                                .elementAt(index)
                                                .toString()
                                                .substring(
                                                    1,
                                                    meaningDefinitionsMap.values
                                                            .elementAt(index)
                                                            .toString()
                                                            .length -
                                                        1)
                                                .replaceAll('.,', '\n•');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ListTile(
                                                  title: SelectableText.rich(
                                                    TextSpan(
                                                        text: '',
                                                        style: body,
                                                        children: [
                                                          TextSpan(
                                                            text: '${key}\n',
                                                            style: bodyItalic,
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                '• ${value.toString()}',
                                                            style: body,
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: (licenseNameController.text != '') |
                                  (licenseUrlsController.text != ''),
                              child: Column(
                                children: [
                                  Divider(
                                    color: Colors.grey[800],
                                    thickness: 2,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: SelectableText(
                                      "License name: ${licenseNameController.text}",
                                      style: corporate,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: SelectableText(
                                      "License URLs: ${licenseUrlsController.text}",
                                      style: corporate,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: SelectableText(
                                      "Source URLs: ${sourceUrlsController.text}",
                                      style: corporate,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: meaningDefinitionsMap.isNotEmpty,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          top: 8,
                                        ),
                                        child: Tooltip(
                                            message: "Clear all output fields.",
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.grey[200],
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.lightImpact();
                                                  setState(() {
                                                    clearAllOutput(
                                                        alsoSearch: true,
                                                        alsoWord: true);
                                                  });
                                                  // shift focus back to input textfield
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          inputFocusNode);
                                                })),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4.0,
                                        ),
                                        child: Text(
                                          "Definitions from Dictionary API",
                                          style: corporate,
                                        ),
                                      ),
                                      Tooltip(
                                          message:
                                              'WordDefiner uses the free Dictionary API to fetch results. Please consider donating to the API provider by visiting dictionaryapi.dev to help keep their server running, and mention WordDefiner if you do so.',
                                          child: Icon(
                                            Icons.info_outline_rounded,
                                            color: Colors.grey,
                                            size: 12,
                                          ))
                                    ],
                                  ),
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
          ],
        ),
      ),
    );
  }
}
