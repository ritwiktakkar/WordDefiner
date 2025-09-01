import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Manages app state, controllers, and variables for WordDefiner
class AppState {
  // Text controllers
  final inputController = TextEditingController();
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

  // Focus nodes
  final inputFocusNode = FocusNode();

  // Audio player
  final audioPlayer = AudioPlayer();

  // State variables
  String wordToDefine = "";
  String? phonetic = '';
  String? pronounciationAudioSource = '';
  String? pronounciationSourceUrl = '';
  String wordExample = '';
  bool finding = false;
  bool isBadWord = false;

  // Word counts
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

  // Expansion tile states
  bool definitionsTileExpanded = false;
  bool stronglyAssociatedTileExpanded = false;
  bool similarlySpeltTileExpanded = false;
  bool similarSoundingTileExpanded = false;
  bool rhymingTileExpanded = false;
  bool followedByTileExpanded = false;
  bool precededByTileExpanded = false;
  bool nounsModifiedTileExpanded = false;
  bool adjectivesModifiedTileExpanded = false;
  bool synonymsTileExpanded = false;
  bool antonymsTileExpanded = false;
  bool hypernymsTileExpanded = false;
  bool hyponymsTileExpanded = false;
  bool holonymsTileExpanded = false;
  bool meronymsTileExpanded = false;

  // Data structures
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

  List<String> badWords = [];
  List<String> words = [];

  /// Clears output fields based on parameters
  void clearOutput({
    bool alsoSearch = true,
    bool alsoWord = true,
    bool definitionsOnly = true,
    bool similarWords = true,
  }) {
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

  /// Disposes of all controllers and resources
  void dispose() {
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
  }
}
