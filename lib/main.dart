import 'package:flutter/material.dart';
import 'dialogs.dart';
import 'package:WordDefiner/services/get_definition.dart' as API;
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

  void clearAllOutput({bool alsoSearch = true, bool alsoWord = true}) {
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
    color: Colors.grey[300],
    fontWeight: FontWeight.w300,
    fontSize: 18,
  );

  TextStyle word = TextStyle(
    color: Colors.blue[400],
    fontWeight: FontWeight.w500,
    fontSize: 30,
  );

  TextStyle body = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  TextStyle bodyItalic = TextStyle(
    color: Colors.blue[200],
    fontStyle: FontStyle.italic,
    fontSize: 18,
  );

  TextStyle synonymsAntonyms = TextStyle(
    color: Colors.grey[300],
    fontWeight: FontWeight.w300,
    fontSize: 17,
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black, // make background color black
        body: Container(
          padding: EdgeInsets.only(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            top: screenHeight * 0.06,
          ),
          height: screenHeight * 0.96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // outputWord shown only if definition found on server
              Visibility(
                visible: outputWordController.text.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenWidth * .75,
                          child: SelectableText(
                            outputWordController.text,
                            style: word,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          width: screenWidth * .15,
                          child: Visibility(
                            visible: pronounciationAudioSource != '',
                            child: Tooltip(
                              message:
                                  'Press to hear the pronounciation of \"${outputWordController.text.toLowerCase()}\". If you can\'t hear anything, try restarting the app.',
                              child: IconButton(
                                icon: Icon(
                                  Icons.hearing,
                                  color: Colors.blue[300],
                                  size: 24,
                                ),
                                onPressed: () {
                                  audioPlayer.setVolume(1);
                                  audioPlayer.play(
                                      UrlSource(pronounciationAudioSource!));
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
              Visibility(
                visible: outputWordController.text.isEmpty,
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: "Definitions will appear here",
                      border: InputBorder.none),
                ),
              ),
              // divider between outputWord and phonetic
              Visibility(
                visible: outputWordController.text.isNotEmpty,
                child: Divider(
                  color: Colors.grey[800],
                  thickness: 2,
                ),
              ),
              // phonetic
              Visibility(
                visible: outputPhoneticController.text.isNotEmpty,
                child: Row(
                  children: [
                    Container(
                      width: screenWidth * .3,
                      child: Text(
                        "Phonetic",
                        style: sectionTitle,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.62,
                      child: SelectableText(
                        outputPhoneticController.text,
                        style: subsectionTitle,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              // divider between phonetic and definitions
              Visibility(
                visible: outputPhoneticController.text.isNotEmpty,
                child: Divider(
                  color: Colors.grey[800],
                  thickness: 2,
                ),
              ),
              // definitions
              Visibility(
                visible: meaningDefinitionsMap.isNotEmpty,
                child: Text(
                  "Definitions",
                  style: sectionTitle,
                ),
              ),
              Expanded(
                child: RawScrollbar(
                  thumbColor: Colors.grey,
                  thickness: 4,
                  radius: Radius.circular(5),
                  child: SingleChildScrollView(
                    child: Visibility(
                      visible: meaningDefinitionsMap.isNotEmpty,
                      child: Column(
                        children: [
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemCount: meaningDefinitionsMap.keys.length,
                              itemBuilder: (BuildContext context, int index) {
                                String key =
                                    meaningDefinitionsMap.keys.elementAt(index);
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
                                    .replaceAll('.,', '\n•');
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // part of speech
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '${key}',
                                        style: bodyItalic,
                                      ),
                                    ),
                                    // definitions for that part of speech
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "• ${value.toString()}",
                                        style: body,
                                      ),
                                    )
                                  ],
                                );
                              }),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
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
                  ),
                ),
              ),
              // Bottom toolbar containing disclaimer and textField for lookup
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth * 0.75,
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        focusNode: inputFocusNode,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                          ),
                          hintText: 'Look up a word',
                        ),
                        controller: inputController,
                        onSubmitted: ((String wordToDefine) async {
                          wordToDefine = wordToDefine.trim();
                          if (wordToDefine == '') {
                            // CHECK 1: empty word - do nothing
                            DoNothingAction();
                            inputController.clear();
                          } else if (!validInputLetters
                                  .hasMatch(wordToDefine) ||
                              wordToDefine.characters.contains(' ')) {
                            // CHECK 2: non letter or space detected
                            Dialogs.showInputIssue(context);
                            setState(() {
                              clearAllOutput(alsoSearch: true, alsoWord: true);
                            });
                          } else {
                            setState(() {
                              clearAllOutput(alsoSearch: true, alsoWord: true);
                            });
                            final definitionsList =
                                (await API.getDefinition(wordToDefine));
                            setState(() {
                              debugPrint("wordToDefine: ${wordToDefine}");
                              if (definitionsList.isNotFound == true) {
                                debugPrint('404 word not found');
                                Dialogs.showNoDefinitions(
                                    context, wordToDefine);
                                clearAllOutput(
                                    alsoSearch: true, alsoWord: true);
                                // shift focus back to input textfield
                                FocusScope.of(context)
                                    .requestFocus(inputFocusNode);
                              } else if (definitionsList.isNull == true) {
                                debugPrint('!caught exception!');
                                Dialogs.showNetworkIssues(context);
                              } else {
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
                                  element.phonetics?.forEach((elementPhonetic) {
                                    debugPrint('enter 2');
                                    if (elementPhonetic.audio == null ||
                                        elementPhonetic.audio == '') {
                                      DoNothingAction();
                                    } else {
                                      pronounciationAudioSource =
                                          elementPhonetic.audio as String;
                                    }
                                    // 2.2 - for audio source
                                    if (elementPhonetic.sourceUrl == null ||
                                        elementPhonetic.sourceUrl == '') {
                                      DoNothingAction();
                                    } else {
                                      pronounciationSourceUrl =
                                          elementPhonetic.sourceUrl as String;
                                    }
                                    // 2.3 - find some phonetic if not already there since phonetics list also has some
                                    // debugPrint('1-${phonetic}');
                                    if (phonetic == '' &&
                                        elementPhonetic.text != null) {
                                      phonetic = elementPhonetic.text as String;
                                    }
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
                                      elementMeaning.definitions?.forEach(
                                          (elementMeaningDefinitions) {
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
                                      : (licenseNames.add(
                                          element.license?.name as String)));
                                  // 4.2 - check if license url in licenseUrls already
                                  (licenseUrls.contains(element.license?.url)
                                      ? DoNothingAction()
                                      : (licenseUrls.add(
                                          element.license?.url as String)));
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
                      ),
                    ),
                  ),
                  Tooltip(
                    message:
                        'By using this app you agree to exempt it from any responsibility regarding the contents shown herein. Definitions are provided by dictionaryapi.dev',
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ),
                  // clear all icon that appears if definitions are present
                  Visibility(
                    visible: meaningDefinitionsMap.isNotEmpty,
                    child: Tooltip(
                        message: "Clear all output fields",
                        child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey[200],
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                clearAllOutput(
                                    alsoSearch: true, alsoWord: true);
                              });
                              // shift focus back to input textfield
                              FocusScope.of(context)
                                  .requestFocus(inputFocusNode);
                            })),
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
