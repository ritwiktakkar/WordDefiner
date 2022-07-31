class Definition {
  final String word;
  final String phonetic;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;
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
    return Definition(
      word: parsedJson['word'],
      phonetic: parsedJson['phonetic'],
      phonetics: parsedJson['phonetics'],
      meanings: parsedJson['meanings'],
      license: parsedJson['license'],
      sourceUrls: parsedJson['sourceUrls'],
    );
  }
}

class Phonetic {
  final String text;
  final String audio;
  final String sourceUrl;
  final List<License> license;

  Phonetic({
    required this.text,
    required this.audio,
    required this.sourceUrl,
    required this.license,
  });

  factory Phonetic.fromJson(Map<String, dynamic> parsedJson) {
    return Phonetic(
      text: parsedJson['text'],
      audio: parsedJson['audio'],
      sourceUrl: parsedJson['sourceUrl'],
      license: parsedJson['license'],
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definitions> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  factory Meaning.fromJson(Map<String, dynamic> parsedJson) {
    return Meaning(
      partOfSpeech: parsedJson['partOfSpeech'],
      definitions: parsedJson['definitions'],
      synonyms: parsedJson['synonyms'],
      antonyms: parsedJson['antonyms'],
    );
  }
}

class Definitions {
  final String definition;
  final List<String> synonyms;
  final List<String> antonyms;
  final String example;

  Definitions({
    required this.definition,
    required this.synonyms,
    required this.antonyms,
    required this.example,
  });

  factory Definitions.fromJson(Map<String, dynamic> parsedJson) {
    return Definitions(
      definition: parsedJson['definition'],
      synonyms: parsedJson['synonyms'],
      antonyms: parsedJson['antonyms'],
      example: parsedJson['example'],
    );
  }
}

class License {
  final String name;
  final String url;

  License({
    required this.name,
    required this.url,
  });

  factory License.fromJson(Map<String, dynamic> parsedJson) {
    return License(
      name: parsedJson['text'],
      url: parsedJson['url'],
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