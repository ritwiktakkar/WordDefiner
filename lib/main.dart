import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'dialogs.dart';
import 'styles.dart';
import 'app_constants.dart';
import 'app_state.dart';
import 'word_search_handler.dart';
import 'custom_button.dart';
import 'readBadWords.dart' as ReadBadWords;
import 'readWords.dart' as ReadWords;
import 'Analytics/constants.dart' as Constants;

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
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // Use dynamic colors when available
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Fallback to custom color schemes when dynamic colors aren't available
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.black,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false, // hide debug banner from top left
          title: "WordDefiner",
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode
              .system, // Automatically switch based on system preference
          home: new HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppState appState;
  CustomButton menuResult = CustomButton.other;

  // Constants for SharedPreferences keys
  static const String _installDateKey = 'install_date';
  static const String _lastReviewDateKey = 'last_review_date';
  static const String _appOpensSinceReviewKey = 'app_opens_since_review';

  void clearSearch() {
    HapticFeedback.lightImpact();
    appState.inputController.clear();
    // shift focus back to input textfield
    FocusScope.of(context).requestFocus(appState.inputFocusNode);
  }

  @override
  void dispose() {
    appState.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    appState = AppState();
    Dialogs.initPackageInfo();
    ReadBadWords.readBadWordsFromFile().then((value) {
      setState(() {
        appState.badWords = value;
      });
    });
    ReadWords.readWordsFromFile().then((value) {
      setState(() {
        appState.words = value;
      });
    });
    _handleAppLaunch();
  }

  Future<void> _handleAppLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // Ensure install date is recorded
    String? installDateStr = prefs.getString(_installDateKey);
    DateTime installDate;
    if (installDateStr == null) {
      installDate = now;
      await prefs.setString(_installDateKey, installDate.toIso8601String());
    } else {
      installDate = DateTime.tryParse(installDateStr) ?? now;
    }

    // Retrieve stored values
    String? lastDateStr = prefs.getString(_lastReviewDateKey);
    DateTime? lastReviewDate;
    if (lastDateStr != null && lastDateStr.isNotEmpty) {
      try {
        lastReviewDate = DateTime.parse(lastDateStr);
      } catch (_) {
        lastReviewDate = null; // Parsing failed
      }
    }

    int appOpens = prefs.getInt(_appOpensSinceReviewKey) ?? 0;

    // Debug information for developer
    int limit = (lastReviewDate == null) ? 4 : 25;
    int launchesRemaining = limit - (appOpens + 1);
    if (launchesRemaining < 0) launchesRemaining = 0;
    DateTime? windowEnd;
    if (lastReviewDate != null) {
      windowEnd = lastReviewDate.add(const Duration(days: 30));
    } else {
      windowEnd = installDate.add(const Duration(days: 4));
    }
    debugPrint('[InAppReview] Last triggered: '
        '${lastReviewDate?.toIso8601String() ?? "never"}');
    debugPrint('[InAppReview] Launches remaining until next prompt: '
        '$launchesRemaining');
    debugPrint('[InAppReview] Time window ends: '
        '${windowEnd.toIso8601String()}');

    bool daysPassed = false;
    if (lastReviewDate != null) {
      daysPassed = now.difference(lastReviewDate).inDays >= 30;
    }

    bool shouldRequest = false;
    if (lastReviewDate == null) {
      // App has never shown review. Wait until 4th launch OR 4th day
      bool fourDays = now.difference(installDate).inDays >= 4;
      bool fourLaunches = appOpens + 1 >= 4;
      shouldRequest = fourDays || fourLaunches;
    } else {
      // Subsequent logic: 30 days OR 20 launches
      shouldRequest = daysPassed || appOpens + 1 >= 20;
    }

    if (shouldRequest) {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        try {
          await inAppReview.requestReview();
          await prefs.setString(_lastReviewDateKey, now.toIso8601String());
          await prefs.setInt(_appOpensSinceReviewKey, 0);
        } catch (_) {
          // requestReview may throw on some platforms; fallthrough to counting
          await prefs.setInt(_appOpensSinceReviewKey, appOpens + 1);
        }
        return;
      }
    }

    // Increment counter if we didn't request review
    await prefs.setInt(_appOpensSinceReviewKey, appOpens + 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(builder: (context) {
        return Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.only(
                  top: 65, left: 20, right: 20, bottom: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
                ),
                height: 40,
                child: TextField(
                  focusNode: appState.inputFocusNode,
                  decoration: InputDecoration.collapsed(
                    focusColor:
                        Theme.of(context).colorScheme.primary.withAlpha(200),
                    hintText: (appState.finding)
                        ? 'Searching “${appState.wordToDefine}”'
                        : 'Search',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  controller: appState.inputController,
                  onSubmitted: (word) async {
                    await WordSearchHandler.handleWordSearch(
                      searchTerm: word,
                      context: context,
                      setWordToDefine: (value) =>
                          setState(() => appState.wordToDefine = value),
                      setFinding: (value) =>
                          setState(() => appState.finding = value),
                      clearOutput: appState.clearOutput,
                      clearInput: () => appState.inputController.clear(),
                      setOutputWord: (value) =>
                          appState.outputWordController.text = value,
                      setIsBadWord: (value) =>
                          setState(() => appState.isBadWord = value),
                      setPhonetic: (value) {
                        appState.phonetic = value;
                        appState.outputPhoneticController.text = value ?? '';
                      },
                      setPronunciationAudioSource: (value) =>
                          appState.pronounciationAudioSource = value,
                      setPronunciationSourceUrl: (value) {
                        appState.pronounciationSourceUrl = value;
                        appState.pronounciationSourceController.text =
                            value ?? '';
                      },
                      setMeaningDefinitionsMap: (value) => setState(
                          () => appState.meaningDefinitionsMap = value),
                      setMeaningSynonymMap: (value) =>
                          setState(() => appState.meaningSynonymMap = value),
                      setMeaningAntonymMap: (value) =>
                          setState(() => appState.meaningAntonymMap = value),
                      setLicenseNames: (value) {
                        setState(() => appState.licenseNames = value);
                        appState.licenseNameController.text = value.join(', ');
                      },
                      setLicenseUrls: (value) {
                        setState(() => appState.licenseUrls = value);
                        appState.licenseUrlsController.text = value.join(', ');
                      },
                      setSourceUrls: (value) {
                        setState(() => appState.sourceUrls = value);
                        appState.sourceUrlsController.text = value.join(', ');
                      },
                      setMeaningPartOfSpeechList: (value) => setState(
                          () => appState.meaningPartOfSpeechList = value),
                      setStronglyAssociatedWords: (value) => appState
                          .stronglyAssociatedWordsController.text = value,
                      setSimilarlySpelledWords: (value) =>
                          appState.similarlySpelledWordsController.text = value,
                      setSimilarSoundingWords: (value) =>
                          appState.similarSoundingWordsController.text = value,
                      setRhymingWords: (value) =>
                          appState.rhymingWordsController.text = value,
                      setFollowedByWords: (value) =>
                          appState.followedByWordsController.text = value,
                      setPrecededByWords: (value) =>
                          appState.precededByWordsController.text = value,
                      setNounsModified: (value) =>
                          appState.nounsModifiedController.text = value,
                      setAdjectivesModified: (value) =>
                          appState.adjectivesModifiedController.text = value,
                      setSynonyms: (value) =>
                          appState.synonymsController.text = value,
                      setAntonyms: (value) =>
                          appState.antonymsController.text = value,
                      setHypernyms: (value) =>
                          appState.hypernymsController.text = value,
                      setHyponyms: (value) =>
                          appState.hyponymsController.text = value,
                      setHolonyms: (value) =>
                          appState.holonymsController.text = value,
                      setMeronyms: (value) =>
                          appState.meronymsController.text = value,
                      setWordResults: (category, count) => setState(() {
                        // Update word result counts based on category
                        switch (category) {
                          case 'stronglyAssociated':
                            appState.stronglyAssociatedWordsCount = count;
                            break;
                          case 'similarSpelled':
                            appState.similarSpeltWordsCount = count;
                            break;
                          case 'similarSounding':
                            appState.similarSoundingWordsCount = count;
                            break;
                          case 'rhyming':
                            appState.rhymingWordsCount = count;
                            break;
                          case 'followedBy':
                            appState.followedByWordsCount = count;
                            break;
                          case 'precededBy':
                            appState.precededByWordsCount = count;
                            break;
                          case 'nounsModified':
                            appState.nounsModifiedCount = count;
                            break;
                          case 'adjectivesModified':
                            appState.adjectivesModifiedCount = count;
                            break;
                          case 'synonyms':
                            appState.synonymsCount = count;
                            break;
                          case 'antonyms':
                            appState.antonymsCount = count;
                            break;
                          case 'hypernyms':
                            appState.hypernymsCount = count;
                            break;
                          case 'hyponyms':
                            appState.hyponymsCount = count;
                            break;
                          case 'holonyms':
                            appState.holonymsCount = count;
                            break;
                          case 'meronyms':
                            appState.meronymsCount = count;
                            break;
                        }
                      }),
                      words: appState.words,
                      badWords: appState.badWords,
                      inputFocusNode: appState.inputFocusNode,
                      validInputLetters: AppConstants.validInputLetters,
                    );
                  },
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  readOnly: (appState.finding) ? true : false,
                ),
              ),
            ),
            // Result column
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: (screenHeight > 1200) // large comp/tab
                    ? screenHeight * 0.8
                    : (Platform.isIOS) // iPhone
                        ? (screenHeight > 900)
                            ? screenHeight * 0.74
                            : screenHeight * 0.71
                        : (Platform.isAndroid) // Android
                            ? screenHeight * 0.72
                            : screenHeight * 0.71, // default
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: (!appState.finding &&
                              appState.outputWordController.text.isEmpty &&
                              appState.wordToDefine.isNotEmpty &&
                              (appState.stronglyAssociatedWordsController.text
                                      .isNotEmpty ||
                                  appState.similarlySpelledWordsController.text
                                      .isNotEmpty ||
                                  appState.similarSoundingWordsController.text
                                      .isNotEmpty)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                                (appState.wordToDefine.characters.length > 0)
                                    ? "No definition found for “${appState.wordToDefine[0].toUpperCase()}${appState.wordToDefine.substring(1).toLowerCase()}” — but here's what we did find:"
                                    : "",
                                style: AppStyles.fail(context)),
                          ),
                        ),
                        Visibility(
                          visible: (!appState.finding &&
                              appState.outputWordController.text.isEmpty &&
                              appState.wordToDefine.isNotEmpty &&
                              appState.stronglyAssociatedWordsController.text
                                  .isEmpty &&
                              appState.similarlySpelledWordsController.text
                                  .isEmpty &&
                              appState
                                  .similarSoundingWordsController.text.isEmpty),
                          child: Container(
                            height: 100,
                            child: Text(
                              (appState.wordToDefine.characters.length > 0)
                                  ? "No definition found for “${appState.wordToDefine[0].toUpperCase()}${appState.wordToDefine.substring(1).toLowerCase()}”"
                                  : "",
                              style: AppStyles.fail(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //
                    Visibility(
                      visible: appState.meaningDefinitionsMap.isNotEmpty,
                      child: Container(
                        height: (appState
                                    .outputPhoneticController.text.isNotEmpty ||
                                appState.pronounciationAudioSource != '')
                            ? 85
                            : 55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth * 0.9,
                              // color: Colors.amber,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    (MediaQuery.of(context).orientation ==
                                            Orientation.landscape)
                                        ? appState.outputWordController.text
                                        : (screenHeight < 1200 &&
                                                appState.outputWordController
                                                        .text.length >
                                                    18) // portrait
                                            ? appState.outputWordController.text
                                                    .substring(0, 18) +
                                                '...'
                                            : appState
                                                .outputWordController.text,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                  ),
                                  Visibility(
                                      visible: appState.isBadWord,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 5),
                                          Tooltip(
                                            message:
                                                "\"${appState.outputWordController.text}\" may be offensive depending on context",
                                            child: InkWell(
                                              child: Icon(
                                                Icons.warning_sharp,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: screenWidth * .9,
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: appState.outputPhoneticController
                                        .text.isNotEmpty,
                                    child: SelectableText(
                                      appState.outputPhoneticController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        appState.pronounciationAudioSource !=
                                            '',
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Tooltip(
                                          message:
                                              'Tap to hear the pronounciation of \"${appState.outputWordController.text.toLowerCase()}.\" If you can\'t hear anything, check the device volume.',
                                          child: InkWell(
                                            child: Icon(
                                              Icons.hearing,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 20,
                                            ),
                                            onTap: () {
                                              appState.audioPlayer.setVolume(1);
                                              if (appState
                                                      .pronounciationAudioSource !=
                                                  null) {
                                                appState.audioPlayer.play(
                                                    UrlSource(appState
                                                        .pronounciationAudioSource!));
                                              }
                                            },
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
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible:
                                  appState.meaningDefinitionsMap.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Text(
                                  appState.meaningDefinitionsMap.length > 1
                                      ? "Definitions for ${appState.meaningDefinitionsMap.length} parts of speech"
                                      : "Definition",
                                  style: AppStyles.sectionTitle(context),
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
                                          itemCount: appState
                                              .meaningDefinitionsMap.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String key = appState
                                                .meaningDefinitionsMap.keys
                                                .elementAt(index);
                                            String value = appState
                                                .meaningDefinitionsMap.values
                                                .elementAt(index)
                                                .toString()
                                                .substring(
                                                    1,
                                                    appState.meaningDefinitionsMap
                                                            .values
                                                            .elementAt(index)
                                                            .toString()
                                                            .length -
                                                        1)
                                                .replaceAll('.,', '\n\u2022');
                                            List<String>? meaningSynonymList =
                                                appState
                                                    .meaningSynonymMap[index];
                                            List<String>? meaningAntonymList =
                                                appState
                                                    .meaningAntonymMap[index];
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // part of speech
                                                Text(
                                                  "${index + 1}. Part of speech: ${key[0].toUpperCase()}${key.substring(1).toLowerCase()}",
                                                  style: AppStyles.partOfSpeech(
                                                      context),
                                                ),
                                                // definitions for that part of speech
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    "\u2022 ${value.toString()}",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: meaningSynonymList !=
                                                          null &&
                                                      meaningSynonymList
                                                          .isNotEmpty,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      'Synonyms: ${meaningSynonymList?.join(', ') ?? ''}',
                                                      style: AppStyles.synonyms(
                                                          context),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: meaningAntonymList !=
                                                          null &&
                                                      meaningAntonymList
                                                          .isNotEmpty,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      'Antonyms: ${meaningAntonymList?.join(', ') ?? ''}',
                                                      style: AppStyles.antonyms(
                                                          context),
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
                                              visible: appState
                                                      .pronounciationAudioSource !=
                                                  '',
                                              child: Text(
                                                'Pronunciation: ${appState.pronounciationSourceController.text}',
                                                style: AppStyles.corporate(
                                                    context),
                                              ),
                                            ),
                                            SelectableText(
                                              "License name: ${appState.licenseNameController.text}",
                                              style:
                                                  AppStyles.corporate(context),
                                              maxLines: 1,
                                            ),
                                            SelectableText(
                                              "License URLs: ${appState.licenseUrlsController.text}",
                                              style:
                                                  AppStyles.corporate(context),
                                              maxLines: 1,
                                            ),
                                            SelectableText(
                                              "Source URLs: ${appState.sourceUrlsController.text}",
                                              style:
                                                  AppStyles.corporate(context),
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
                                    appState.definitionsTileExpanded = expanded;
                                  });
                                },
                                initiallyExpanded: true,
                              ),
                            ),
                            Visibility(
                              visible:
                                  appState.synonymsController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      appState.synonymsCount > 1
                                          ? "${appState.synonymsCount} synonyms"
                                          : "${appState.synonymsCount} synonym",
                                      style: AppStyles.synonyms(context),
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
                                          appState.synonymsController.text,
                                          style: AppStyles.synonyms(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.synonymsTileExpanded = expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible:
                                  appState.antonymsController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      appState.antonymsCount > 1
                                          ? "${appState.antonymsCount} antonyms"
                                          : "${appState.antonymsCount} antonym",
                                      style: AppStyles.antonyms(context),
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
                                          appState.antonymsController.text,
                                          style: AppStyles.antonyms(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.antonymsTileExpanded = expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: appState
                                  .stronglyAssociatedWordsController
                                  .text
                                  .isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      appState.stronglyAssociatedWordsCount > 1
                                          ? "${appState.stronglyAssociatedWordsCount} strongly associated words"
                                          : "${appState.stronglyAssociatedWordsCount} strongly associated word",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState.stronglyAssociatedWordsController
                                          .text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.stronglyAssociatedTileExpanded =
                                        expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: appState
                                  .precededByWordsController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Often preceded by ${appState.precededByWordsCount > 1 ? appState.precededByWordsCount : appState.precededByWordsCount} words",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState.precededByWordsController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.precededByTileExpanded = expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: appState
                                  .followedByWordsController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Often followed by ${appState.followedByWordsCount > 1 ? appState.followedByWordsCount : appState.followedByWordsCount} words",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState.followedByWordsController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.followedByTileExpanded = expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: appState
                                  .nounsModifiedController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Often describes ${appState.nounsModifiedCount} ${appState.nounsModifiedCount > 1 ? "nouns" : "noun"}",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState.nounsModifiedController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.nounsModifiedTileExpanded =
                                        expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: appState
                                  .adjectivesModifiedController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Often described by ${appState.adjectivesModifiedCount} ${appState.adjectivesModifiedCount > 1 ? "adjectives" : "adjective"}",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState
                                          .adjectivesModifiedController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.adjectivesModifiedTileExpanded =
                                        expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible:
                                  appState.hypernymsController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      appState.hypernymsCount > 1
                                          ? "${appState.hypernymsCount} hypernyms "
                                          : "${appState.hypernymsCount} hypernym ",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                    Tooltip(
                                      message:
                                          'Hypernyms are words that are more general than the word being defined.',
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState.hypernymsController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.hypernymsTileExpanded = expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible:
                                  appState.hyponymsController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (appState.hyponymsCount > 1)
                                          ? "${appState.hyponymsCount} hyponyms "
                                          : "${appState.hyponymsCount} hyponym ",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                    Tooltip(
                                      message:
                                          'Hyponyms are words that are more specific than the word being defined.',
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState.hyponymsController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.hyponymsTileExpanded = expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible:
                                  appState.holonymsController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (appState.holonymsCount > 1)
                                          ? "${appState.holonymsCount} holonyms "
                                          : "${appState.holonymsCount} holonym ",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                    Tooltip(
                                      message:
                                          'Holonyms are words that define the whole, whereas meronyms define the parts.',
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState.holonymsController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.holonymsTileExpanded = expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: appState.similarlySpelledWordsController
                                  .text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (appState.similarSpeltWordsCount > 1)
                                          ? "${appState.similarSpeltWordsCount} similarly spelled words "
                                          : "${appState.similarSpeltWordsCount} similarly spelled word ",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState
                                          .similarlySpelledWordsController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.similarlySpeltTileExpanded =
                                        expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: appState.similarSoundingWordsController
                                  .text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (appState.similarSoundingWordsCount > 1)
                                          ? "${appState.similarSoundingWordsCount} similar sounding words "
                                          : "${appState.similarSoundingWordsCount} similar sounding word ",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState
                                          .similarSoundingWordsController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.similarSoundingTileExpanded =
                                        expanded;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: appState
                                  .rhymingWordsController.text.isNotEmpty,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                expandedAlignment: Alignment.topLeft,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (appState.rhymingWordsCount > 1)
                                          ? "${appState.rhymingWordsCount} rhyming words "
                                          : "${appState.rhymingWordsCount} rhyming word ",
                                      style: AppStyles.sectionTitle(context),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SelectableText(
                                      appState.rhymingWordsController.text,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    appState.rhymingTileExpanded = expanded;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppConstants.appInfo,
                          style: AppStyles.corporate(context),
                        ),
                        Tooltip(
                          message: "Clear all output fields",
                          child: IconButton(
                              iconSize: 32,
                              icon: Icon(
                                Icons.delete,
                                color:
                                    (appState.meaningDefinitionsMap
                                                .isNotEmpty ||
                                            appState
                                                .stronglyAssociatedWordsController
                                                .text
                                                .isNotEmpty ||
                                            appState
                                                .similarlySpelledWordsController
                                                .text
                                                .isNotEmpty ||
                                            appState
                                                .similarSoundingWordsController
                                                .text
                                                .isNotEmpty)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withAlpha(100)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withAlpha(5),
                              ),
                              onPressed: () {
                                if (appState.meaningDefinitionsMap.isNotEmpty ||
                                    appState.stronglyAssociatedWordsController
                                        .text.isNotEmpty ||
                                    appState.similarlySpelledWordsController
                                        .text.isNotEmpty ||
                                    appState.similarSoundingWordsController.text
                                        .isNotEmpty) {
                                  HapticFeedback.mediumImpact();
                                  setState(() {
                                    appState.clearOutput(
                                        alsoSearch: true,
                                        alsoWord: true,
                                        definitionsOnly: true,
                                        similarWords: true);
                                    appState.wordToDefine = '';
                                  });
                                  // shift focus back to input textfield
                                  FocusScope.of(context)
                                      .requestFocus(appState.inputFocusNode);
                                } else {
                                  DoNothingAction();
                                }
                              }),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Text(
                                "WordDefiner",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              Tooltip(
                                message: '${AppConstants.appDisclaimer}',
                                child: Icon(
                                  Icons.policy_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withAlpha(150),
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Action buttons
                        IconButton(
                          tooltip: "Open menu",
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 40, minHeight: 40),
                          onPressed: () async {
                            if (Platform.isLinux) {
                              menuResult = await Dialogs.showMenuLinux(context);
                              if (menuResult == CustomButton.positiveButton) {
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  launchUrl(Uri.parse(Constants.formUrl));
                                });
                              } else if (menuResult ==
                                  CustomButton.negativeButton) {
                                DoNothingAction();
                              } else if (menuResult ==
                                  CustomButton.neutralButton) {
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  launchUrl(Uri.parse(Constants.githubURL));
                                });
                              }
                            } else {
                              menuResult = await Dialogs.showMenu(context);
                              if (menuResult == CustomButton.positiveButton) {
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  launchUrl(Uri.parse(Constants.formUrl));
                                });
                              } else if (menuResult ==
                                  CustomButton.neutralButton) {
                                DoNothingAction();
                              } else if (menuResult ==
                                  CustomButton.negativeButton) {
                                inAppReview.openStoreListing(
                                  appStoreId: 'id1637774027',
                                );
                              }
                            }
                          },
                          icon: Icon(Icons.menu,
                              size: 20,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withAlpha(150)),
                        ),

                        Visibility(
                          visible: Platform.isAndroid || Platform.isIOS,
                          child: IconButton(
                            tooltip: "See more of my apps",
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: () async {
                              menuResult = await Dialogs.showMoreApps(context);
                              if (menuResult == CustomButton.negativeButton) {
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  launchUrl(Uri.parse((Platform.isAndroid)
                                      ? Constants.playStoreURL
                                      : Constants.appStoreURL));
                                });
                              }
                            },
                            icon: Icon(Icons.more_outlined,
                                size: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withAlpha(150)),
                          ),
                        ),

                        IconButton(
                          tooltip: (Platform.isLinux)
                              ? "Get WordDefiner on your phone"
                              : "Share this app",
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 40, minHeight: 40),
                          onPressed: () async {
                            if (Platform.isLinux) {
                              menuResult =
                                  await Dialogs.showSmartphoneMenu(context);
                              if (menuResult == CustomButton.positiveButton) {
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  launchUrl(
                                      Uri.parse(Constants.worddefinerURLApple));
                                });
                              } else if (menuResult ==
                                  CustomButton.neutralButton) {
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  launchUrl(Uri.parse(
                                      Constants.worddefinerURLAndroid));
                                });
                              }
                            } else {
                              await SharePlus.instance.share(ShareParams(
                                  text:
                                      "Try the lightweight, powerful, and free English dictionary, thesaurus, and rhyming words app, WordDefiner: " +
                                          (Platform.isAndroid
                                              ? Constants.worddefinerURLAndroid
                                              : Constants
                                                  .worddefinerURLApple)));
                            }
                          },
                          icon: Icon(
                              (Platform.isLinux)
                                  ? Icons.smartphone
                                  : (Platform.isAndroid)
                                      ? Icons.share
                                      : Icons.ios_share,
                              size: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withAlpha(150)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
