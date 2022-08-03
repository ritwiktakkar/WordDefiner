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
  // Create a text controller and use it to retrieve the current value of the TextField.
  final inputController = TextEditingController();
  final outputWordController = TextEditingController();
  final outputPhoneticController = TextEditingController();
  final pronounciationSourceController = TextEditingController();
  final meaningPartOfSpeechController = TextEditingController();
  final meaningDefinitionController = TextEditingController();
  // final meaningSynonymsController = TextEditingController();
  // final meaningAntonymsController = TextEditingController();
  final meaningExampleController = TextEditingController();
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

  void clearAllOutput({bool alsoWord = false}) {
    // FocusScope.of(context).unfocus();
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
    meaningExampleController.clear();
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

  TextStyle body = TextStyle(
    color: CupertinoColors.white,
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  TextStyle bodyItalic = TextStyle(
    color: CupertinoColors.white,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
    fontSize: 17,
  );

  TextStyle synonymsAntonyms = TextStyle(
    color: CupertinoColors.extraLightBackgroundGray,
    fontWeight: FontWeight.w300,
    fontSize: 17,
  );

  TextStyle subsectionTitle = TextStyle(
    color: CupertinoColors.white,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  TextStyle corporate = TextStyle(
    color: CupertinoColors.systemGrey,
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
    meaningExampleController.dispose();
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
                        clearAllOutput();
                        outputWordController.text = wordToDefine.toLowerCase();
                        final definitionsList =
                            (await API.getDefinition(wordToDefine));
                        if (definitionsList.isNotFound == true) {
                          debugPrint('404 word not found');
                          // clearAllOutput();
                          Dialogs.showNoDefinitions(context);
                        } else if (definitionsList.isNull == true) {
                          debugPrint('!caught exception!');
                          // clearAllOutput();
                          Dialogs.showNetworkIssues(context);
                        } else {
                          // traverse through list of definitions and assign to controllers so user can see
                          definitionsList.definitionElements
                              ?.forEach((element) {
                            // 1 - for phonetic (assign last phonetic to outputPhoneticController.text)
                            (((element.phonetic != '') &&
                                    (element.phonetic != null))
                                ? (phonetic = element.phonetic as String)
                                : (phonetic = ''));
                            // 2 - for pronounciation (look through each field in phonetics and assign last audio to pronounciationAudioSource)
                            // 2.1 - for audio
                            element.phonetics?.forEach((elementPhonetic) {
                              (((elementPhonetic.audio != '') ||
                                      (elementPhonetic.audio != null))
                                  ? (pronounciationAudioSource =
                                      elementPhonetic.audio as String)
                                  : (pronounciationAudioSource = ''));
                              // 2.2 - for audio source
                              (((elementPhonetic.sourceUrl != '') ||
                                      (elementPhonetic.sourceUrl != null))
                                  ? (pronounciationSourceUrl =
                                      elementPhonetic.sourceUrl as String)
                                  : (pronounciationSourceUrl = ''));
                            });
                            // 3 - for meanings (look through each field in meanings)
                            element.meanings?.forEach((elementMeaning) {
                              // 3.1 - add part of speech to list
                              meaningPartOfSpeechList
                                  .add(elementMeaning.partOfSpeech as String);
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
                                meaningDefinitionsMap[elementMeaning
                                    .partOfSpeech] = meaningDefinitionsList_1;
                                // debugPrint(
                                //     'meaningDefinitionsList_1: ${meaningDefinitionsList_1}; meaningDefinitionsMap: ${meaningDefinitionsMap}');
                                meaningDefinitionsList_1 = [];
                              }
                            });
                            // 4 - for license
                            // 4.1 -  check if license name in licenseNames already
                            (licenseNames.contains(element.license?.name)
                                ? (debugPrint(
                                    '${element.license?.name} already in licenseNames'))
                                : (licenseNames
                                    .add(element.license?.name as String)));
                            // 4.2 - check if license url in licenseUrls already
                            (licenseUrls.contains(element.license?.url)
                                ? (debugPrint(
                                    '${element.license?.url} already in licenseUrls'))
                                : (licenseUrls
                                    .add(element.license?.url as String)));
                            // 5 - for source urls (check if license name in licenseNames already)
                            element.sourceUrls?.forEach((elementSourceUrl) {
                              (sourceUrls.contains(elementSourceUrl)
                                  ? (debugPrint(
                                      '${elementSourceUrl} already in sourceUrls'))
                                  : (sourceUrls.add(elementSourceUrl)));
                            });
                          });

                          // assign phonetic to phonetic controller
                          outputPhoneticController.text = phonetic!;
                          // assign pronounciationSourceController.text to pronounciationSourceUrl
                          pronounciationSourceController.text =
                              pronounciationSourceUrl!;
                          // assign sourceUrls list to its text editing controller
                          sourceUrlsController.text = sourceUrls.join(', ');
                          // assign license lists to their respective text editing controllers
                          licenseNameController.text = licenseNames.join(', ');
                          licenseUrlsController.text = licenseUrls.join(', ');
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
                                          // padding: EdgeInsets.only(
                                          //   left: screenWidth * 0.03,
                                          // ),
                                          width: screenWidth * .7,
                                          child: AutoSizeText(
                                            outputPhoneticController.text,
                                            style: subsectionTitle,
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
                                            width: screenWidth * .4,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    CupertinoIcons
                                                        .speaker_2_fill,
                                                    color: CupertinoColors
                                                        .activeBlue,
                                                    // size: screenHeight * 0.05,
                                                  ),
                                                  onPressed: () {
                                                    audioPlayer.play(UrlSource(
                                                        pronounciationAudioSource!));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible:
                                          pronounciationSourceController.text !=
                                              '',
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                                pronounciationSourceController
                                                    .text,
                                                style: corporate),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      // divider between first and second half of widgets
                                      color: Colors.grey[800],
                                      thickness: 2,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Meanings",
                                              style: sectionTitle,
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible:
                                              meaningDefinitionsMap.isNotEmpty,
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.all(0),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      meaningDefinitionsMap
                                                          .keys.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    String key =
                                                        meaningDefinitionsMap
                                                            .keys
                                                            .elementAt(index);
                                                    String value = meaningDefinitionsMap
                                                        .values
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
                                                        .replaceAll('.,', ';');
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        ListTile(
                                                          title: RichText(
                                                              text: TextSpan(
                                                                  text: '',
                                                                  style: body,
                                                                  children: [
                                                                TextSpan(
                                                                  text:
                                                                      '${key}\n',
                                                                  style:
                                                                      bodyItalic,
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '${value.toString()}',
                                                                  style: body,
                                                                ),
                                                              ])),
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
                                      visible: (licenseNameController.text !=
                                              '') |
                                          (licenseUrlsController.text != ''),
                                      child: Column(
                                        children: [
                                          Divider(
                                            color: Colors.grey[800],
                                            thickness: 2,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "License name: ${licenseNameController.text}",
                                                  style: corporate,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "License URLs: ${licenseUrlsController.text}",
                                                  style: corporate,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "Source URLs: ${sourceUrlsController.text}",
                                                  style: corporate,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Visibility(
                                          visible:
                                              outputWordController.text != '',
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 8,
                                            ),
                                            child: Tooltip(
                                                message:
                                                    "Clear all output fields",
                                                child: IconButton(
                                                    icon: Icon(
                                                      CupertinoIcons.delete,
                                                      color: CupertinoColors
                                                          .lightBackgroundGray,
                                                    ),
                                                    onPressed: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      clearAllOutput(
                                                          alsoWord: true);
                                                    }
                                                    // clearAllOutput(
                                                    //     alsoWord: true),

                                                    // {
                                                    //   debugPrint(
                                                    //       'pressed clear!');
                                                    //   // FocusScope.of(context)
                                                    //   //     .unfocus();
                                                    //   HapticFeedback
                                                    //       .mediumImpact();
                                                    //   clearAllOutput(
                                                    //       alsoWord: true);
                                                    // },
                                                    )),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Definitions from Dictionary API: dictionaryapi.dev/",
                  style: corporate,
                ),
                SizedBox(
                  width: screenWidth * 0.05,
                ),
                Tooltip(
                    message:
                        'The developer of the API used by this app (not me) provides it for free. Please consider donating by visiting the website below to help keep the server running, and mention this app\'s name when you do so.',
                    child: Icon(
                      CupertinoIcons.info,
                      color: CupertinoColors.inactiveGray,
                      size: 20,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
