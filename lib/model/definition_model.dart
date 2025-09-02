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
  List<String>? synonymsEl;
  List<String>? antonymsEl;

  Meanings(
      {this.partOfSpeech, this.definitions, this.synonymsEl, this.antonymsEl});

  Meanings.fromJson(Map<String, dynamic> json) {
    partOfSpeech = json['partOfSpeech'];

    if (json['definitions'] != null) {
      definitions = <Definitions>[];
      json['definitions'].forEach((v) {
        definitions!.add(new Definitions.fromJson(v));
      });
    }

    if (json['synonymsEl'] != null) {
      synonymsEl = <String>[];
      json['synonymsEl'].forEach((v) {
        synonymsEl!.add(v);
      });
    }

    if (json['antonymsEl'] != null) {
      antonymsEl = <String>[];
      json['antonymsEl'].forEach((v) {
        antonymsEl!.add(v);
      });
    }

    synonymsEl = json['synonyms'].cast<String>();
    antonymsEl = json['antonyms'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partOfSpeech'] = this.partOfSpeech;
    if (this.definitions != null) {
      data['definitions'] = this.definitions!.map((v) => v.toJson()).toList();
    }
    data['synonymsEl'] = this.synonymsEl;
    data['antonymsEl'] = this.antonymsEl;
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
