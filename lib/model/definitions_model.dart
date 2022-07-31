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
