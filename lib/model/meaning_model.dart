import 'package:iDefine/model/definitions_model.dart';

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
