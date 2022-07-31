class Definition {
  final String word; // done
  final String phonetic; // done
  final PhoneticsList phonetics;
  final MeaningsList meanings;
  final License license; // done
  final List<String> sourceUrls; // done

  Definition({
    required this.word,
    required this.phonetic,
    required this.phonetics,
    required this.meanings,
    required this.license,
    required this.sourceUrls,
  });

  factory Definition.fromJson(Map<String, dynamic> parsedJson) {
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

class PhoneticsList {
  final List<Phonetic> phonetics;

  PhoneticsList({
    required this.phonetics,
  });

  factory PhoneticsList.fromJson(List<dynamic> parsedJson) {
    List<Phonetic> phonetics = <Phonetic>[];
    phonetics = parsedJson.map((i) => Phonetic.fromJson(i)).toList();

    return new PhoneticsList(phonetics: phonetics);
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
    var licensesFromJson = parsedJson['license'];
    List<License> licensesList = licensesFromJson.cast<Phonetic>();

    return Phonetic(
      text: parsedJson['text'],
      audio: parsedJson['audio'],
      sourceUrl: parsedJson['sourceUrl'],
      license: licensesList,
    );
  }
}

class MeaningsList {
  final List<Meaning> meanings;

  MeaningsList({
    required this.meanings,
  });

  factory MeaningsList.fromJson(List<dynamic> parsedJson) {
    List<Meaning> meanings = <Meaning>[];
    meanings = parsedJson.map((i) => Meaning.fromJson(i)).toList();

    return new MeaningsList(meanings: meanings);
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
    var definitionsFromJson = parsedJson['definitions'];
    List<Definitions> definitionsList = definitionsFromJson.cast<Definitions>();

    var synonymsFromJson = parsedJson['synonyms'];
    List<String> synonymsList = synonymsFromJson.cast<String>();

    var antonymsFromJson = parsedJson['antonyms'];
    List<String> antonymsList = antonymsFromJson.cast<String>();

    return Meaning(
      partOfSpeech: parsedJson['partOfSpeech'],
      definitions: definitionsList,
      synonyms: synonymsList,
      antonyms: antonymsList,
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
    var synonymsFromJson = parsedJson['synonyms'];
    List<String> synonymsList = synonymsFromJson.cast<String>();

    var antonymsFromJson = parsedJson['antonyms'];
    List<String> antonymsList = antonymsFromJson.cast<String>();

    return Definitions(
      definition: parsedJson['definition'],
      synonyms: synonymsList,
      antonyms: antonymsList,
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