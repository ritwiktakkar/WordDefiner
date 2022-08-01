class Definition {
  final String word; // done
  final String? phonetic; // done
  final PhoneticsList? phonetics;
  final MeaningsList? meanings;
  final License? license; // done
  final List<String>? sourceUrls; // done

  Definition({
    required this.word,
    this.phonetic,
    this.phonetics,
    this.meanings,
    this.license,
    this.sourceUrls,
  });

  factory Definition.fromJson(Map<String, dynamic> parsedJson) {
    var sourceUrlsFromJson = parsedJson['sourceUrls'];
    List<String> sourceUrlsList = sourceUrlsFromJson.cast<String>();

    return new Definition(
      word: parsedJson['word'],
      phonetic: parsedJson['phonetic'],
      phonetics: PhoneticsList.fromJson(parsedJson['phonetics']),
      meanings: parsedJson['meanings'],
      license: parsedJson['license'],
      sourceUrls: sourceUrlsList,
    );
  }
}

class DefinitionList {
  final List<Definition>? definitions;

  DefinitionList({this.definitions});

  factory DefinitionList.fromJson(List<dynamic> parsedJson) {
    List<Definition> definitions = <Definition>[];
    definitions = parsedJson.map((i) => Definition.fromJson(i)).toList();
    return new DefinitionList(definitions: definitions);
  }
}

class PhoneticsList {
  final List<Phonetic>? phonetics;

  PhoneticsList({
    this.phonetics,
  });

  factory PhoneticsList.fromJson(List<dynamic> parsedJson) {
    List<Phonetic> phonetics = <Phonetic>[];
    phonetics = parsedJson.map((i) => Phonetic.fromJson(i)).toList();

    return new PhoneticsList(phonetics: phonetics);
  }
}

class Phonetic {
  final String? text;
  final String? audio;
  final String? sourceUrl;
  final List<License>? license;

  Phonetic({
    this.text,
    this.audio,
    this.sourceUrl,
    this.license,
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
  final List<Meaning>? meanings;

  MeaningsList({
    this.meanings,
  });

  factory MeaningsList.fromJson(List<dynamic> parsedJson) {
    List<Meaning> meanings = <Meaning>[];
    meanings = parsedJson.map((i) => Meaning.fromJson(i)).toList();

    return new MeaningsList(meanings: meanings);
  }
}

class Meaning {
  final String? partOfSpeech;
  final List<Definitions>? definitions;
  final List<String>? synonyms;
  final List<String>? antonyms;

  Meaning({
    this.partOfSpeech,
    this.definitions,
    this.synonyms,
    this.antonyms,
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
  final String? definition;
  final List<String>? synonyms;
  final List<String>? antonyms;
  final String? example;

  Definitions({
    this.definition,
    this.synonyms,
    this.antonyms,
    this.example,
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
  final String? name;
  final String? url;

  License({
    this.name,
    this.url,
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