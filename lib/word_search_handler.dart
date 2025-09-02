import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:WordDefiner/services/dictionaryAPI.dart' as FreeDictionaryAPI;
import 'package:WordDefiner/services/datamuseAPI.dart' as DatamuseAPI;
import 'dialogs.dart';

/// Handles word search logic and API calls
class WordSearchHandler {
  static Future<void> handleWordSearch({
    required String searchTerm,
    required BuildContext context,
    required Function(String) setWordToDefine,
    required Function(bool) setFinding,
    required Function() clearOutput,
    required Function() clearInput,
    required Function(String) setOutputWord,
    required Function(bool) setIsBadWord,
    required Function(String?) setPhonetic,
    required Function(String?) setPronunciationAudioSource,
    required Function(String?) setPronunciationSourceUrl,
    required Function(Map) setMeaningDefinitionsMap,
    required Function(Map) setMeaningSynonymMap,
    required Function(Map) setMeaningAntonymMap,
    required Function(List<String>) setLicenseNames,
    required Function(List<String>) setLicenseUrls,
    required Function(List<String>) setSourceUrls,
    required Function(List<String>) setMeaningPartOfSpeechList,
    required Function(String) setStronglyAssociatedWords,
    required Function(String) setSimilarlySpelledWords,
    required Function(String) setSimilarSoundingWords,
    required Function(String) setRhymingWords,
    required Function(String) setFollowedByWords,
    required Function(String) setPrecededByWords,
    required Function(String) setNounsModified,
    required Function(String) setAdjectivesModified,
    required Function(String) setSynonyms,
    required Function(String) setAntonyms,
    required Function(String) setHypernyms,
    required Function(String) setHyponyms,
    required Function(String) setHolonyms,
    required Function(String) setMeronyms,
    required Function(String, int) setWordResults,
    required List<String> words,
    required List<String> badWords,
    required FocusNode inputFocusNode,
    required RegExp validInputLetters,
  }) async {
    final trimmedTerm = searchTerm.trim();

    if (trimmedTerm == '') {
      // Empty word - do nothing
      setFinding(false);
      clearInput();
      return;
    }

    if (!validInputLetters.hasMatch(trimmedTerm) ||
        trimmedTerm.contains(' ') ||
        trimmedTerm.length > 50) {
      // Invalid input - show error dialog
      Dialogs.showInputIssue(context);
      // shift focus back to input textfield
      FocusScope.of(context).requestFocus(inputFocusNode);
      return;
    }

    // Check internet connection
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      debugPrint("no internet connection");
      Future.delayed(Duration(seconds: 1), () {
        Dialogs.showNetworkIssues(context);
        setFinding(false);
        clearInput();
        setWordToDefine('');
      });
      return;
    }

    // Check if word is recognized or get user confirmation
    if (!words.contains(trimmedTerm.toLowerCase()) &&
        await Dialogs.showUnrecognizedWord(context) != AlertButton.yesButton) {
      return;
    }

    // Start search process
    setWordToDefine(trimmedTerm);
    setFinding(true);
    clearOutput();

    try {
      debugPrint("sent request to get definitions");

      // Fetch definition data
      final definitionsList =
          await FreeDictionaryAPI.getDefinition(trimmedTerm);

      // Fetch all other data concurrently for better performance
      final wordDataFutures = await Future.wait([
        DatamuseAPI.getRelatedWords(trimmedTerm),
        DatamuseAPI.getSimilarSpeltWords(trimmedTerm),
        DatamuseAPI.getSimilarSoundingWords(trimmedTerm),
        DatamuseAPI.getRhymingWords(trimmedTerm),
        DatamuseAPI.getFollowedByWords(trimmedTerm),
        DatamuseAPI.getPrecededByWords(trimmedTerm),
        DatamuseAPI.getNounsModified(trimmedTerm),
        DatamuseAPI.getAdjectivesModified(trimmedTerm),
        DatamuseAPI.getSynonyms(trimmedTerm),
        DatamuseAPI.getAntonyms(trimmedTerm),
        DatamuseAPI.getHypernyms(trimmedTerm),
        DatamuseAPI.getHyponyms(trimmedTerm),
        DatamuseAPI.getHolonyms(trimmedTerm),
        DatamuseAPI.getMeronyms(trimmedTerm),
      ]);

      final relatedWords = wordDataFutures[0];
      final similarSpelledWords = wordDataFutures[1];
      final similarSoundingWords = wordDataFutures[2];
      final rhymingWords = wordDataFutures[3];
      final followedByWords = wordDataFutures[4];
      final precededByWords = wordDataFutures[5];
      final nounsModified = wordDataFutures[6];
      final adjectivesModified = wordDataFutures[7];
      final synonyms = wordDataFutures[8];
      final antonyms = wordDataFutures[9];
      final hypernyms = wordDataFutures[10];
      final hyponyms = wordDataFutures[11];
      final holonyms = wordDataFutures[12];
      final meronyms = wordDataFutures[13];

      // Set word results with counts
      setWordResults('stronglyAssociated', relatedWords?.length ?? 0);
      setWordResults('similarSpelled', similarSpelledWords?.length ?? 0);
      setWordResults('similarSounding', similarSoundingWords?.length ?? 0);
      setWordResults('rhyming', rhymingWords?.length ?? 0);
      setWordResults('followedBy', followedByWords?.length ?? 0);
      setWordResults('precededBy', precededByWords?.length ?? 0);
      setWordResults('nounsModified', nounsModified?.length ?? 0);
      setWordResults('adjectivesModified', adjectivesModified?.length ?? 0);
      setWordResults('synonyms', synonyms?.length ?? 0);
      setWordResults('antonyms', antonyms?.length ?? 0);
      setWordResults('hypernyms', hypernyms?.length ?? 0);
      setWordResults('hyponyms', hyponyms?.length ?? 0);
      setWordResults('holonyms', holonyms?.length ?? 0);
      setWordResults('meronyms', meronyms?.length ?? 0);

      debugPrint("received request to get definitions");
      setFinding(false);

      debugPrint("definitions list: ${definitionsList}");

      // Always set word data from API results regardless of definition found
      setStronglyAssociatedWords(formatWordList(relatedWords));
      setSimilarlySpelledWords(formatWordList(similarSpelledWords));
      setSimilarSoundingWords(formatWordList(similarSoundingWords));
      setRhymingWords(formatWordList(rhymingWords));
      setFollowedByWords(formatWordList(followedByWords));
      setPrecededByWords(formatWordList(precededByWords));
      setNounsModified(formatWordList(nounsModified));
      setAdjectivesModified(formatWordList(adjectivesModified));
      setSynonyms(formatWordList(synonyms));
      setAntonyms(formatWordList(antonyms));
      setHypernyms(formatWordList(hypernyms));
      setHyponyms(formatWordList(hyponyms));
      setHolonyms(formatWordList(holonyms));
      setMeronyms(formatWordList(meronyms));

      if (definitionsList != null && definitionsList.isNotFound == true) {
        debugPrint('404 word not found');
        // Don't clear output - keep the similar/associated words visible
        FocusScope.of(context).requestFocus(inputFocusNode);
      } else if (definitionsList != null && definitionsList.isNull == true) {
        debugPrint('definitions list is null');
        Future.delayed(Duration(seconds: 1), () {
          Dialogs.showNetworkIssues(context);
          setFinding(false);
          clearInput();
          setWordToDefine('');
        });
      } else {
        try {
          HapticFeedback.lightImpact();
          setOutputWord(
              "${trimmedTerm[0].toUpperCase()}${trimmedTerm.substring(1).toLowerCase()}");

          if (badWords.contains(trimmedTerm.toLowerCase())) {
            setIsBadWord(true);
          } else {
            setIsBadWord(false);
          }

          await _processDefinitions(
            definitionsList,
            setPhonetic,
            setPronunciationAudioSource,
            setPronunciationSourceUrl,
            setMeaningDefinitionsMap,
            setMeaningSynonymMap,
            setMeaningAntonymMap,
            setLicenseNames,
            setLicenseUrls,
            setSourceUrls,
            setMeaningPartOfSpeechList,
          );
        } on Exception catch (e) {
          debugPrint('!caught exception! $e');
          Future.delayed(Duration(seconds: 1), () {
            Dialogs.showNetworkIssues(context);
            setFinding(false);
            clearInput();
            setWordToDefine('');
          });
        }
      }
    } on Exception catch (e) {
      debugPrint('!caught exception! $e');
      Future.delayed(Duration(seconds: 1), () {
        Dialogs.showNetworkIssues(context);
        setFinding(false);
        clearInput();
        setWordToDefine('');
      });
    }
  }

  static Future<void> _processDefinitions(
    dynamic definitionsList,
    Function(String?) setPhonetic,
    Function(String?) setPronunciationAudioSource,
    Function(String?) setPronunciationSourceUrl,
    Function(Map) setMeaningDefinitionsMap,
    Function(Map) setMeaningSynonymMap,
    Function(Map) setMeaningAntonymMap,
    Function(List<String>) setLicenseNames,
    Function(List<String>) setLicenseUrls,
    Function(List<String>) setSourceUrls,
    Function(List<String>) setMeaningPartOfSpeechList,
  ) async {
    String? phonetic = '';
    String? pronunciationAudioSource = '';
    String? pronunciationSourceUrl = '';

    List<String> meaningPartOfSpeechList = <String>[];
    List<String> meaningDefinitionsList_tmp = <String>[];
    List<String> meaningSynonymsList_tmp = <String>[];
    List<String> meaningAntonymsList_tmp = <String>[];

    var meaningDefinitionsMap = <String, dynamic>{};
    var meaningSynonymMap = <String, dynamic>{};
    var meaningAntonymMap = <String, dynamic>{};

    List<String> licenseNames = <String>[];
    List<String> licenseUrls = <String>[];
    List<String> sourceUrls = <String>[];

    // Process definitions
    definitionsList?.definitionElements?.forEach((element) {
      // Process phonetic
      if (element.phonetic != null) {
        phonetic = element.phonetic;
      }

      // Process phonetics for audio
      element.phonetics?.forEach((elementPhonetic) {
        if (elementPhonetic.audio != null && elementPhonetic.audio != '') {
          pronunciationAudioSource = elementPhonetic.audio as String;
        }

        if (elementPhonetic.sourceUrl != null &&
            elementPhonetic.sourceUrl != '') {
          pronunciationSourceUrl = elementPhonetic.sourceUrl as String;
        }

        if (phonetic == '' && elementPhonetic.text != null) {
          phonetic = elementPhonetic.text as String;
        }
      });

      // Process meanings
      element.meanings?.forEach((elementMeaning) {
        meaningPartOfSpeechList.add(elementMeaning.partOfSpeech as String);

        for (int i = 0; i < meaningPartOfSpeechList.length; i++) {
          elementMeaning.definitions?.forEach((elementMeaningDefinitions) {
            meaningDefinitionsList_tmp
                .add(elementMeaningDefinitions.definition as String);
          });
          meaningDefinitionsMap[elementMeaning.partOfSpeech] =
              meaningDefinitionsList_tmp;
          meaningDefinitionsList_tmp = [];

          elementMeaning.synonymsEl?.forEach((element) {
            meaningSynonymsList_tmp.add(element);
          });
          meaningSynonymMap[elementMeaning.partOfSpeech] =
              meaningSynonymsList_tmp;
          meaningSynonymsList_tmp = [];

          elementMeaning.antonymsEl?.forEach((element) {
            meaningAntonymsList_tmp.add(element);
          });
          meaningAntonymMap[elementMeaning.partOfSpeech] =
              meaningAntonymsList_tmp;
          meaningAntonymsList_tmp = [];
        }
      });

      // Process license
      if (!licenseNames.contains(element.license?.name)) {
        licenseNames.add(element.license?.name as String);
      }
      if (!licenseUrls.contains(element.license?.url)) {
        licenseUrls.add(element.license?.url as String);
      }

      // Process source URLs
      element.sourceUrls?.forEach((elementSourceUrl) {
        if (!sourceUrls.contains(elementSourceUrl)) {
          sourceUrls.add(elementSourceUrl);
        }
      });
    });

    // Set all processed data
    setPhonetic(phonetic);
    setPronunciationAudioSource(pronunciationAudioSource);
    setPronunciationSourceUrl(pronunciationSourceUrl);
    setMeaningDefinitionsMap(meaningDefinitionsMap);
    setMeaningSynonymMap(meaningSynonymMap);
    setMeaningAntonymMap(meaningAntonymMap);
    setLicenseNames(licenseNames);
    setLicenseUrls(licenseUrls);
    setSourceUrls(sourceUrls);
    setMeaningPartOfSpeechList(meaningPartOfSpeechList);
  }

  static String formatWordList(List<String>? words) {
    if (words == null || words.isEmpty) return '';
    return words.toString().substring(1, words.toString().length - 1);
  }
}
