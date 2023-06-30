class DefinitionForm {
  String query;
  String isFound;

  DefinitionForm(this.query, this.isFound);

  Map toJson() => {'query': query, 'isFound': isFound};
}
