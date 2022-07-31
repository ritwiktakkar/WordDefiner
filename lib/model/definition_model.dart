import 'package:iDefine/model/phonetic_model.dart';
import 'package:iDefine/model/meaning_model.dart';
import 'package:iDefine/model/license_model.dart';

class Definition {
  final String word;
  final String phonetic;
  final PhoneticsList phonetics;
  final MeaningsList meanings;
  final License license;
  final List<String> sourceUrls;

  Definition({
    required this.word,
    required this.phonetic,
    required this.phonetics,
    required this.meanings,
    required this.license,
    required this.sourceUrls,
  });

  factory Definition.fromJson(Map<String, dynamic> parsedJson) {
    // var phoneticsFromJson = parsedJson['phonetics'];
    // List<Phonetic> phoneticsList = phoneticsFromJson.cast<Phonetic>();

    // var meaningsFromJson = parsedJson['meanings'];
    // List<Meaning> meaningsList = meaningsFromJson.cast<Meaning>();

    var sourceUrlsFromJson = parsedJson['sourceUrls'];
    List<String> sourceUrlsList = sourceUrlsFromJson.cast<String>();

    return new Definition(
      word: parsedJson['word'],
      phonetic: parsedJson['phonetic'],
      phonetics: parsedJson['phonetics'],
      meanings: parsedJson['meanings'],
      license: parsedJson['license'],
      sourceUrls: sourceUrlsList,
    );
  }
}

// Below is awesome.json
// [
//     {
//         "word": "awesome",
//         "phonetic": "/ˈɔːsəm/",
//         "phonetics": [
//             {
//                 "text": "/ˈɔːsəm/",
//                 "audio": ""
//             },
//             {
//                 "text": "/ˈɔs.əm/",
//                 "audio": "https://api.dictionaryapi.dev/media/pronunciations/en/awesome-us.mp3",
//                 "sourceUrl": "https://commons.wikimedia.org/w/index.php?curid=811897",
//                 "license": {
//                     "name": "BY-SA 3.0",
//                     "url": "https://creativecommons.org/licenses/by-sa/3.0"
//                 }
//             }
//         ],
//         "meanings": [
//             {
//                 "partOfSpeech": "noun",
//                 "definitions": [
//                     {
//                         "definition": "Short for awesomeness: the quality, state, or essence of being awesome.",
//                         "synonyms": [],
//                         "antonyms": [],
//                         "example": "pure awesome; made of awesome"
//                     }
//                 ],
//                 "synonyms": [
//                     "awesome sauce"
//                 ],
//                 "antonyms": [
//                     "fail",
//                     "shit",
//                     "weaksauce"
//                 ]
//             },
//             {
//                 "partOfSpeech": "adjective",
//                 "definitions": [
//                     {
//                         "definition": "Causing awe or terror; inspiring wonder or excitement.",
//                         "synonyms": [],
//                         "antonyms": [],
//                         "example": "The tsunami was awesome in its destructive power."
//                     },
//                     {
//                         "definition": "Excellent, exciting, remarkable.",
//                         "synonyms": [],
//                         "antonyms": [],
//                         "example": "Awesome, dude!"
//                     }
//                 ],
//                 "synonyms": [],
//                 "antonyms": [
//                     "aweless"
//                 ]
//             }
//         ],
//         "license": {
//             "name": "CC BY-SA 3.0",
//             "url": "https://creativecommons.org/licenses/by-sa/3.0"
//         },
//         "sourceUrls": [
//             "https://en.wiktionary.org/wiki/awesome"
//         ]
//     }
// ]