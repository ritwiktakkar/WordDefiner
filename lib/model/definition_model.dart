class DefinitionElementList {
  final List<DefinitionElement>? definitionElements;
  final bool? isNull;
  final bool? isNotFound;

  DefinitionElementList({
    this.definitionElements,
    this.isNotFound,
    this.isNull,
  });

  factory DefinitionElementList.fromJson(List<dynamic> parsedJson) {
    List<DefinitionElement> definitionElements = <DefinitionElement>[];
    definitionElements =
        parsedJson.map((i) => DefinitionElement.fromJson(i)).toList();

    return new DefinitionElementList(definitionElements: definitionElements);
  }
}

class DefinitionElement {
  String? word;
  String? phonetic;
  List<Phonetics>? phonetics;
  List<Meanings>? meanings;
  License? license;
  List<String>? sourceUrls;

  DefinitionElement(
      {this.word,
      this.phonetic,
      this.phonetics,
      this.meanings,
      this.license,
      this.sourceUrls});

  DefinitionElement.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    phonetic = json['phonetic'];
    if (json['phonetics'] != null) {
      phonetics = <Phonetics>[];
      json['phonetics'].forEach((v) {
        phonetics!.add(new Phonetics.fromJson(v));
      });
    }
    if (json['meanings'] != null) {
      meanings = <Meanings>[];
      json['meanings'].forEach((v) {
        meanings!.add(new Meanings.fromJson(v));
      });
    }
    license =
        json['license'] != null ? new License.fromJson(json['license']) : null;
    sourceUrls = json['sourceUrls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['phonetic'] = this.phonetic;
    if (this.phonetics != null) {
      data['phonetics'] = this.phonetics!.map((v) => v.toJson()).toList();
    }
    if (this.meanings != null) {
      data['meanings'] = this.meanings!.map((v) => v.toJson()).toList();
    }
    if (this.license != null) {
      data['license'] = this.license!.toJson();
    }
    data['sourceUrls'] = this.sourceUrls;
    return data;
  }
}

class Phonetics {
  String? text;
  String? audio;
  String? sourceUrl;
  License? license;

  Phonetics({this.text, this.audio, this.sourceUrl, this.license});

  Phonetics.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    audio = json['audio'];
    sourceUrl = json['sourceUrl'];
    license =
        json['license'] != null ? new License.fromJson(json['license']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['audio'] = this.audio;
    data['sourceUrl'] = this.sourceUrl;
    if (this.license != null) {
      data['license'] = this.license!.toJson();
    }
    return data;
  }
}

class License {
  String? name;
  String? url;

  License({this.name, this.url});

  License.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Meanings {
  String? partOfSpeech;
  List<Definitions>? definitions;
  List<String>? synonyms;
  List<String>? antonyms;

  Meanings({this.partOfSpeech, this.definitions, this.synonyms, this.antonyms});

  Meanings.fromJson(Map<String, dynamic> json) {
    partOfSpeech = json['partOfSpeech'];

    if (json['definitions'] != null) {
      definitions = <Definitions>[];
      json['definitions'].forEach((v) {
        definitions!.add(new Definitions.fromJson(v));
      });
    }

    if (json['synonyms'] != null) {
      synonyms = <String>[];
      json['synonyms'].forEach((v) {
        synonyms!.add(v);
      });
    }

    if (json['antonyms'] != null) {
      antonyms = <String>[];
      json['antonyms'].forEach((v) {
        antonyms!.add(v);
      });
    }

    synonyms = json['synonyms'].cast<String>();
    antonyms = json['antonyms'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partOfSpeech'] = this.partOfSpeech;
    if (this.definitions != null) {
      data['definitions'] = this.definitions!.map((v) => v.toJson()).toList();
    }
    data['synonyms'] = this.synonyms;
    data['antonyms'] = this.antonyms;
    return data;
  }
}

class Definitions {
  String? definition;
  // String? example;

  Definitions({
    this.definition,
    // this.example,
  });

  Definitions.fromJson(Map<String, dynamic> json) {
    definition = json['definition'];
    // example = json['example'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['definition'] = this.definition;
    // data['example'] = this.example;
    return data;
  }
}
